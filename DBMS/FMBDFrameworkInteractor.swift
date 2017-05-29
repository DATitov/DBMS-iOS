//
//  FMBDFrameworkInteractor.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import FMDB

class FMBDFrameworkInteractor: NSObject {
    
    fileprivate func db() -> FMDatabase? {
        return DataBaseConnecter.shared.dataBase(dbFramework: .FMDB) as! FMDatabase?
    }
    
}

extension FMBDFrameworkInteractor: FillingReadDMProtocol {
    
    func tablesCount() -> Int {
        return self.tablesNames().count
    }
    
    func tablesNames() -> [String] {
        guard let db = self.openDB() else {
            return [String]()
        }
        let tablesNames = self.tablesNames(db: db)
        return tablesNames
    }
    
    func table(name: String) -> TableData {
        guard let db = self.openDB() else {
            return TableData(name: "", properties: [])
        }
        let tableData = self.table(name: name, db: db)
        db.close()
        return tableData
    }
    
    func allTables() -> [TableData] {
        guard let db = self.openDB() else {
            return [TableData]()
        }
        let tablesNames = self.tablesNames(db: db)
        var tables = [TableData]()
        for name in tablesNames {
            tables.append(self.table(name: name, db: db))
        }
        db.close()
        return tables
    }
    
    func tableRecords(name: String) -> [Record] {
        guard let db = self.openDB() else {
            return [Record]()
        }
        let executionString = SQLiteExecutionStringGenerator().records(tableName: name)
        guard let result = self.executeFetchRequest(executionString: executionString, db: db) else {
            return [Record]()
        }
        let table = self.table(name: name, db: db)
        var records = [Record]()
        while (result.next()) {
            guard Int32(table.properties.count) == result.columnCount() else {
                continue
            }
            let record = Record(tableData: table)
            for (index, property) in table.properties.enumerated() {
                record.valuesDict[property.name] = result.string(forColumnIndex: Int32(index))
            }
            records.append(record)
        }
        db.close()
        return records
    }
    
}

extension FMBDFrameworkInteractor: FillingWriteDMProtocol {
    
    func addRecord(tableName: String, record: Record, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        let executionStringAddRecord = SQLiteExecutionStringGenerator().addRecord(dbFramework: .FMDB, tableName: tableName, record: record)
        db.executeStatements(executionStringAddRecord)
        db.close()
    }
    
}

extension FMBDFrameworkInteractor: EditingTableCreateDropDMProtocol {
    
    func createTable(tableData: TableData, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        let executionString = SQLiteExecutionStringGenerator().tableCreation(tableData: tableData)
        if !db.executeStatements(executionString) {
            error = DataManagerAPIError.FrameworkExecutionFailure
        }
        db.close()
    }
    
    func dropTable(name: String, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        let executionString = SQLiteExecutionStringGenerator().dropTable(name: name)
        if !db.executeStatements(executionString) {
            error = DataManagerAPIError.FrameworkExecutionFailure
        }
        db.close()
    }
    
}

extension FMBDFrameworkInteractor: EditingTableEditingDMProtocol {
    
    func renameTable(oldTableName: String, newTableName: String, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        self.renameTable(oldTableName: oldTableName, newTableName: newTableName, db: db, error: &error)
        db.close()
    }
    
    func addAttribute(tableName: String, attribute: TableProperty, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        self.addAttribute(tableName: tableName, attribute: attribute, db: db, error: &error)
        db.close()
    }
    
    func removeAttribute(tableName: String, attributeName: String, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        self.removeAttribute(tableName: tableName, attributeName: attributeName, db: db, error: &error)
        db.close()
    }
    
    func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty, error: inout Error?) {
        guard let db = self.openDB() else {
            error = DataManagerAPIError.CanNotConnectToDB
            return
        }
        self.updateAttribute(tableName: tableName, oldAttributeName: oldAttributeName, attribute: attribute, db: db, error: &error)
        db.close()
    }
    
}

extension FMBDFrameworkInteractor { // MARK: Helpers
    
    fileprivate func table(name: String, db: FMDatabase) -> TableData {
        let table = TableData(name: name, properties: [])
        let executionString = "PRAGMA table_info(\(name))"
        guard let result = self.executeFetchRequest(executionString: executionString, db: db) else {
            return table
        }
        while (result.next() ) {
            let name = result.string(forColumn: "name")
            let type = FMDBHelper.shared.dataType(fmdbFrameworkString: result.string(forColumn: "type"))
            let notnull = result.bool(forColumn: "notnull")
            let attribute = TableProperty(name: name!, type: type)
            attribute.nullable = !notnull
            table.properties.append(attribute)
        }
        return table
    }
    
    fileprivate func tablesNames(db: FMDatabase) -> [String] {
        var tablesNames = [String]()
        let executionString = "select * from SQLITE_MASTER"
        guard let result = self.executeFetchRequest(executionString: executionString, db: db) else {
            return tablesNames
        }
        while (result.next() ) {
            let name = result.string(forColumn: "name")
            tablesNames.append(name!)
        }
        return tablesNames
    }
    
    fileprivate func renameTable(oldTableName: String, newTableName: String, db: FMDatabase, error: inout Error?) {
        let executionString = SQLiteExecutionStringGenerator().renameTable(oldTableName: oldTableName, newTableName: newTableName)
        if !db.executeStatements(executionString) {
            error = DataManagerAPIError.FrameworkExecutionFailure
        }
    }
    
    fileprivate func addAttribute(tableName: String, attribute: TableProperty, db: FMDatabase, error: inout Error?) {
        let executionString = SQLiteExecutionStringGenerator().addAttribute(tableName: tableName, attribute: attribute)
        if !db.executeStatements(executionString) {
            error = DataManagerAPIError.FrameworkExecutionFailure
        }
    }
    
    fileprivate func removeAttribute(tableName: String, attributeName: String, db: FMDatabase, error: inout Error?) {
        let executionString = SQLiteExecutionStringGenerator().removeAttribute(tableName: tableName, attributeName: attributeName)
        if !db.executeStatements(executionString) {
            error = DataManagerAPIError.FrameworkExecutionFailure
        }
    }
    
    fileprivate func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty, db: FMDatabase, error: inout Error?) {
        let executionString = SQLiteExecutionStringGenerator().updateAttribute(tableName: tableName, oldAttributeName: oldAttributeName, attribute: attribute)
        if !db.executeStatements(executionString) {
            error = DataManagerAPIError.FrameworkExecutionFailure
        }
    }
    
    fileprivate func openDB() -> FMDatabase? {
        guard let db = self.db() else {
            return nil
        }
        if !db.open() {
            return nil
        }
        return db
    }
    
    fileprivate func executeFetchRequest(executionString: String, db: FMDatabase) -> FMResultSet? {
        var result: FMResultSet?
        do {
            result = try db.executeQuery(executionString, values: [])
        } catch  {
            print()
        }
        return result
    }
    
}
