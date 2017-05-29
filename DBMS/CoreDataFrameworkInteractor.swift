//
//  CoreDataFrameworkInteractor.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class CoreDataFrameworkInteractor: NSObject {
    
    var persistentContainer = Variable<NSPersistentContainer>(DataBaseConnecter.shared.persistentContainer.value)
    
    let disposeBag = DisposeBag()
    
    
    override init() {
        super.init()
        _ = DataBaseConnecter.shared.persistentContainer.asObservable()
            .bindTo(persistentContainer)
            .disposed(by: disposeBag)
    }
    
}

extension CoreDataFrameworkInteractor: FillingReadDMProtocol {
    
    func tablesCount() -> Int {
        return self.tablesNames().count
    }
    
    func tablesNames() -> [String] {
        let list = persistentContainer.value.managedObjectModel.entities
        let names = list.map { $0.name! }
        return names
    }
    
    func table(name: String) -> TableData {
        guard let description = self.entityDescription(name: name) else {
            return TableData(name: "Temple", properties: [])
        }
        return TableData(coreDataEntity: description)
    }
    
    func allTables() -> [TableData] {
        var tables = [TableData]()
        let entities = persistentContainer.value.managedObjectModel.entities
        for entity in entities {
            let table = self.table(description: entity)
            tables.append(table)
        }
        return tables
    }
    
    func tableRecords(name: String) -> [Record] {
        let tableData = self.table(name: name)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        var result: [Any]?
        do {
            result = try self.persistentContainer.value.viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        guard let rawRecords = result else {
            return [Record]()
        }
        let records: [Record] = {
            var result = [Record]()
            for rawRecord in rawRecords as! [NSManagedObject] {
                let record = Record(tableData: tableData)
                for property in tableData.properties {
                    let value = rawRecord.value(forKey: property.name)
                    record.valuesDict[property.name] = value != nil ? "\(value!)" : ""
                }
                result.append(record)
            }
            return result
        }()
        
        return records
    }
    
}

extension CoreDataFrameworkInteractor: FillingWriteDMProtocol {
    
    func addRecord(tableName: String, record: Record, error: inout Error?) {
        let description = self.entityDescription(name: tableName)
        let managedObject = NSManagedObject(entity: description!, insertInto: persistentContainer.value.viewContext)
        let tableData = DataManagerAPI.shared.getTable(dbFramework: .CoreData, name: tableName)
        for (propertyName, propertyType) in tableData.properties.map({ ($0.name, $0.type) }) {
            let value = { () -> Any in
                switch propertyType {
                case .String:
                    return record.stringValue(key: propertyName)
                case .Int64:
                    return record.intValue(key: propertyName)
                case .Double:
                    return record.floatValue(key: propertyName)
                default:
                    return record.stringValue(key: propertyName)
                }
            }()
            managedObject.setValue(value, forKey: propertyName)
        }
        if persistentContainer.value.viewContext.hasChanges {
            do {
                try persistentContainer.value.viewContext.save()
            } catch let e {
                error = e
            }
        }
    }
}

extension CoreDataFrameworkInteractor: EditingTableCreateDropDMProtocol {
    
    func createTable(tableData: TableData, error: inout Error?) {
        let model = persistentContainer.value.managedObjectModel.mutableCopy() as! NSManagedObjectModel
        let entity = tableData.coreDataEntityDescription()
        model.entities.append(entity)
        DataBaseConnecter.shared.updatePersistentContainer(model: model)
    }
    
    func dropTable(name: String, error: inout Error?) {
        let model = persistentContainer.value.managedObjectModel.mutableCopy() as! NSManagedObjectModel
        var entities = [NSEntityDescription]()
        for des in model.entities {
            if des.name?.uppercased() != name.uppercased() {
                entities.append(des)
            }
        }
        model.entities = entities
        DataBaseConnecter.shared.updatePersistentContainer(model: model)
    }
    
}

extension CoreDataFrameworkInteractor: EditingTableEditingDMProtocol {
    
    func renameTable(oldTableName: String, newTableName: String, error: inout Error?) {
        let model = persistentContainer.value.managedObjectModel.mutableCopy() as! NSManagedObjectModel
        for description in model.entities.filter({ $0.name?.uppercased() == oldTableName.uppercased() }) {
            description.name = newTableName
        }
        DataBaseConnecter.shared.updatePersistentContainer(model: model)
    }
    
    func addAttribute(tableName: String, attribute: TableProperty, error: inout Error?) {
        let model = persistentContainer.value.managedObjectModel.mutableCopy() as! NSManagedObjectModel
        guard let alterEntity = self.entity(name: tableName, managedObjectModel: model) else {
            error = DataManagerAPIError.Other
            return
        }
        if alterEntity.properties.filter({ $0.name.uppercased() == attribute.name.uppercased() }).count > 0 {
            error = DataManagerAPIError.Other
            return
        }
        alterEntity.properties.append(attribute.coreDataPropertyDescription())
        DataBaseConnecter.shared.updatePersistentContainer(model: model)
    }
    
    func removeAttribute(tableName: String, attributeName: String, error: inout Error?) {
        let model = persistentContainer.value.managedObjectModel.mutableCopy() as! NSManagedObjectModel
        guard let alterEntity = self.entity(name: tableName, managedObjectModel: model) else {
            error = DataManagerAPIError.Other
            return
        }
        alterEntity.properties = alterEntity.properties.filter({ $0.name.uppercased() != attributeName.uppercased() })
        DataBaseConnecter.shared.updatePersistentContainer(model: model)
    }
    
    func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty, error: inout Error?) {
        let model = persistentContainer.value.managedObjectModel.mutableCopy() as! NSManagedObjectModel
        guard let alterEntity = self.entity(name: tableName, managedObjectModel: model) else {
            error = DataManagerAPIError.Other
            return
        }
        guard let alterProperty = self.property(name: oldAttributeName, entity: alterEntity) else {
            error = DataManagerAPIError.Other
            return
        }
        alterProperty.name = attribute.name
        alterProperty.isOptional = attribute.nullable
        DataBaseConnecter.shared.updatePersistentContainer(model: model)
    }
    
}

extension CoreDataFrameworkInteractor { // MARK: Helpers
    
    fileprivate func table(description: NSEntityDescription) -> TableData {
        let table = TableData(name: (description.name!), properties: [])
        let properties = description.properties
        for prprt in properties { // as NSPropertyDescription
            if prprt.isMember(of: NSAttributeDescription.self) {
                let property = TableProperty(name: prprt.name, type: .String)
                property.type = CoreDataHelper().dataType(attributeType: (prprt as! NSAttributeDescription).attributeType)
                table.properties.append(property)
            }
        }
        return table
    }
    
    fileprivate func entityDescription(name: String) -> NSEntityDescription? {
        let entities = persistentContainer.value.managedObjectModel.entities
        var description: NSEntityDescription?
        for dscrptn in entities {
            if dscrptn.name?.uppercased() == name.uppercased() {
                description = dscrptn
                break
            }
        }
        return description
    }
    
    fileprivate func entity(name: String, managedObjectModel: NSManagedObjectModel) -> NSEntityDescription? {
        let entities = managedObjectModel.entities.filter({ $0.name?.uppercased() == name.uppercased() })
        if entities.count > 0 {
            return entities.first
        }
        return nil
    }
    
    fileprivate func property(name: String, entity: NSEntityDescription) -> NSPropertyDescription? {
        let properties = entity.properties.filter({ $0.name.uppercased() == name.uppercased() })
        if properties.count > 0 {
            return properties.first
        }
        return nil
    }    
    
}
