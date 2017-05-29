//
//  EditTableViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 19.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class EditTableVM: NSObject {
    
    let editingState = Variable<Bool>(false)
    
    var table : TableData!
    
    var cellsModels: [AttributeEditingTVCellModel]!
    
    var dbFramework: DataBaseFramework = .None
    
    private var tableNames = [String]()
    
    init(dbFramework: DataBaseFramework, tableName : String) {
        super.init()
        self.dbFramework = dbFramework
        self.relaunch(tableName: tableName)
    }
    
    func relaunch(tableName: String) {
        self.createTable(name: tableName)
        self.createAttributesModels()
        tableNames = DataManagerAPI.shared.getAllTablesNames(dbFramework: dbFramework)
    }
    
    func createAttributesModels() {
        var models = [AttributeEditingTVCellModel]()
        for attribute in table.properties {
            if attribute.isMember(of: TableProperty.self) {
                models.append(AttributeEditingTVCellModel(titleText: attribute.name, typeText: (attribute).type.rawValue,
                                                          isEditing: editingState.value, selected: false, isForeignKey: false))
            }else{
                models.append(AttributeEditingTVCellModel(titleText: attribute.name, typeText: ((attribute).foreighKey?.tableName)!,
                                                          isEditing: editingState.value, selected: false, isForeignKey: false))
            }
        }
        cellsModels = models
    }
    
    func createTable(name: String) {
        var table: TableData!
        if AppDBChecker.shared.checkTableExist(dbFramework: dbFramework, name: name) {
            table = DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: name)
        }else {
            table = TableData(name: name, properties: [TableProperty]())
        }
        self.table = table
    }
    
    func getNumberOfModels() -> Int {
        return cellsModels.count
    }
    
    func cellModel(index: Int) -> AttributeEditingTVCellModel {
        let count = self.getNumberOfModels()
        if count <= index {
            return AttributeEditingTVCellModel(titleText: "", typeText: "", isEditing: false, selected: false, isForeignKey: false)
        }
        return cellsModels[index]
    }
    
    func updateProperty(propertyName: String, property: TableProperty) {
        var newTable = TableData(name: self.table.name, properties: [TableProperty]() as! [TableProperty])
        for prprt in self.table.properties {
            if prprt.name == propertyName {
                newTable.properties.append(property)
            }else{
                newTable.properties.append(prprt)
            }
        }
        self.table = newTable
    }
    
    func tableNameAvailable(name: String) -> Bool {
        let uppercasedName = name.uppercased()
        for nm in tableNames {
            let uppercasedNM = nm.uppercased()
            if uppercasedName == uppercasedNM {
                return false
            }
        }
        return true
    }
    
    func addAttribute(attribute: TableProperty) {
        let attributesCount = table.properties.count
        table.properties.append(attribute)
        let newAttributesCount = table.properties.count
        if attributesCount == 0 &&
            newAttributesCount >= 1 {
            if self.tableNameAvailable(name: table.name) {
                var error: Error?
                DataManagerAPI.shared.createTable(dbFramework: dbFramework, table: table, error: &error)
                if error != nil {
                    print(error ?? "")
                }
            }
        }else{
            var error: Error?
            DataManagerAPI.shared.addColumn(dbFramework: dbFramework, tableName: table.name, attribute: attribute, error: &error)
            if error != nil {
                print(error ?? "")
            }
        }
    }
    
    func removeAttribute(index: Int) {
        if table.properties.count <= index {
            return
        }
        let attributesCount = table.properties.count
        var error: Error?
        if attributesCount == 1 {
            var error: Error?
            DataManagerAPI.shared.dropTable(dbFramework: dbFramework, name: table.name, error: &error)
        }else{
            DataManagerAPI.shared.removeColumn(dbFramework: dbFramework, tableName: table.name, columnName: table.properties[index].name, error: &error)
        }
        if error != nil {
            print(error ?? "")
        }
        self.createTable(name: table.name)
    }
    
    func renameTable(newName: String) -> Observable<Void> {
        var error: Error?
        DataManagerAPI.shared.renameTable(dbFramework: dbFramework, oldTableName: table.name, newTableName: newName, error: &error)
        return Observable.create({ (observer) -> Disposable in
            if error != nil {
                observer.onError(error!)
            }else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    func dropTable() -> Observable<Void> {
        var error: Error?
        DataManagerAPI.shared.dropTable(dbFramework: dbFramework, name: table.name, error: &error)
        return Observable.create({ (observer) -> Disposable in
            if error != nil {
                observer.onError(error!)
            }else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
}
