//
//  SQLiteFrameworkInteractor.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import SQLite

class SQLiteFrameworkInteractor: NSObject {
    
    fileprivate var db: Connection! = DataBaseConnecter.shared.dataBase(dbFramework: .SQLite) as! Connection! {
        didSet {
            DefaulTablesGenerator.db = db
        }
    }
    
    fileprivate let master_table = Table("SQLITE_MASTER")
    
    override init() {
        super.init()
    }
    
}

extension SQLiteFrameworkInteractor: FillingReadDMProtocol {
    
    func tablesCount() -> Int {
        return self.tablesNames().count
    }
    
    func tablesNames() -> [String] {
        var array = [String]()
        for table in try! db.prepare(master_table) {
            array.append(table[Expression<String>("tbl_name")])
        }
        return array
    }
    
    func table(name: String) -> TableData {
        let executeString = "PRAGMA TABLE_INFO(\"\(name)\");"
        let responce = try! db.prepare(executeString)
        let tableData = TableData(name: name, properties: [])
        for column in responce {
            let type = DataType.getTypeForString(string: column[2] as! String)
            let property = TableProperty(name: column[1] as! String, type: type)
            tableData.properties.append(property)
        }
        return tableData
    }
    
    func allTables() -> [TableData] {
        var array = [TableData]()
        let names = self.tablesNames()
        for name in names {
            array.append(self.table(name: name))
        }
        return array
    }
    
    func tableRecords(name: String) -> [Record] {
        let table = Table(name)
        let tableData = DataManagerAPI.shared.getTable(dbFramework: .SQLite, name: name)
        var records = [Record]()
        do {
            for element in try db.prepare(table) {
                let record =  Record(tableData: tableData)
                for property in tableData.properties {
                    switch property.type {
                    case .String:
                        record.valuesDict[property.name] = element[Expression<String>(property.name)]
                        break
                    case .Int64:
                        record.valuesDict[property.name] = element[Expression<String>(property.name)]
                        break
                    case .Double:
                        record.valuesDict[property.name] = element[Expression<String>(property.name)]
                        break
                    case .None:
                        record.valuesDict[property.name] = element[Expression<String>(property.name)]
                        break
                    }
                }
                records.append(record)
            }
        } catch {
            print()
        }
        return records
    }
    
}

extension SQLiteFrameworkInteractor: FillingWriteDMProtocol {
    
    func addRecord(tableName: String, record: Record, error: inout Error?) {
        let executionString = SQLiteExecutionStringGenerator().addRecord(dbFramework: .SQLite, tableName: tableName, record: record)
        do {
            try db.execute(executionString)
        } catch let e {
            error = e
        }
    }
    
}

extension SQLiteFrameworkInteractor: EditingTableCreateDropDMProtocol {
    
    func createTable(tableData: TableData, error: inout Error?) {
        let table = Table(tableData.name)
        do {
            try db.run(table.create { t in
                for property in tableData.properties {
                    if property.isMember(of: TableProperty.self) {
                        
                        switch (property ).type {
                        case .Int64:
                            let name = Expression<Int64>(property.name)
                            if property.primaryKey {
                                t.column(name, primaryKey: true)
                            }else if property.unique {
                                t.column(name, unique: true)
                            }else {
                                t.column(name)
                            }
                            break
                        case .Double:
                            let name = Expression<Double>(property.name)
                            if property.primaryKey {
                                t.column(name, primaryKey: true)
                            }else if property.unique {
                                t.column(name, unique: true)
                            }else {
                                t.column(name)
                            }
                            break
                        case .String:
                            let name = Expression<String>(property.name)
                            if property.primaryKey {
                                t.column(name, primaryKey: true)
                            }else if property.unique {
                                t.column(name, unique: true)
                            }else {
                                t.column(name)
                            }
                            break
                        default:
                            break
                        }
                        
                    }
                }
            })
        }catch let e{
            error = e as Error?
        }
        return
    }
    
    func dropTable(name: String, error: inout Error?) {
        let table = Table(name)
        do {
            try db.run(table.drop(ifExists: true))
        } catch let e {
            error = e as Error?
        }
    }
    
}

extension SQLiteFrameworkInteractor: EditingTableEditingDMProtocol {
    
    func renameTable(oldTableName: String, newTableName: String, error: inout Error?) {
        let table = Table(oldTableName)
        do {
            try db.run(table.rename(Table(newTableName)))
        } catch let e {
            error = e
        }
    }
    
    func addAttribute(tableName: String, attribute: TableProperty, error: inout Error?) {
        let table = DataManagerAPI.shared.getTable(dbFramework: .SQLite, name: tableName)
        table.properties.append(attribute)
        DataManagerAPI.shared.dropTable(dbFramework: .SQLite, name: tableName, error: &error)
        DataManagerAPI.shared.createTable(dbFramework: .SQLite, table: table, error: &error)
        return
    }
    
    func removeAttribute(tableName: String, attributeName: String, error: inout Error?) {
        let table = DataManagerAPI.shared.getTable(dbFramework: .SQLite, name: tableName)
        DataManagerAPI.shared.dropTable(dbFramework: .SQLite, name: tableName, error: &error)
        if error != nil { return }
        if table.properties.count > 1 {
            var newTableProperties = [TableProperty]()
            for property in table.properties {
                if property.name.uppercased() != attributeName.uppercased() {
                    newTableProperties.append(property)
                }
            }
            let newTableData = TableData(name: tableName, properties: newTableProperties)
            DataManagerAPI.shared.createTable(dbFramework: .SQLite, table: newTableData, error: &error)
        }
        return
    }
    
    func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty, error: inout Error?) {
        let tableData = DataManagerAPI.shared.getTable(dbFramework: .SQLite, name: tableName)
        if tableData.properties.count == 1 {
            DataManagerAPI.shared.dropTable(dbFramework: .SQLite, name: tableName, error: &error)
            if error != nil { return }
            let newTableData = TableData(name: tableName, properties: [attribute])
            DataManagerAPI.shared.createTable(dbFramework: .SQLite, table: newTableData, error: &error)
        }else{
            self.removeAttribute(tableName: tableName, attributeName: attribute.name, error: &error)
            if error != nil { return }
            self.addAttribute(tableName: tableName, attribute: attribute, error: &error)
        }
    }
    
    private func columnsToKeepString(table: TableData, columnToRemoveName: String) -> String {
        var columnsToKeep = [String]()
        for column in table.properties {
            if column.name != columnToRemoveName {
                columnsToKeep.append(column.name)
            }
        }
        let resString = { () -> String in 
            var resString = ""
            for index in 0..<columnsToKeep.count {
                if index == 0 {
                    resString.append(columnsToKeep[index])
                }else{
                    resString.append(", " + columnsToKeep[index])
                }
            }
            return resString
        }()
        return resString
    }
    
}
