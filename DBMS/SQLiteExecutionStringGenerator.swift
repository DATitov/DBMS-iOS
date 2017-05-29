//
//  SQLiteExecutionStringGenerator.swift
//  DBMS
//
//  Created by Dmitrii Titov on 06.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class SQLiteExecutionStringGenerator: NSObject {
    
    func renameTable(oldTableName: String, newTableName: String) -> String {
        let executionString = "ALTER TABLE \(oldTableName) RENAME TO \(newTableName)"
        return executionString
    }
    
    func addAttribute(tableName: String, attribute: TableProperty) -> String {
        let executionString = "ALTER TABLE \(tableName) ADD COLUMN \(FMDBHelper.shared.string(tableProperty: attribute));"
        return executionString
    }
    
    func tableCreation(tableData: TableData) -> String {
        var propertiesString = ""
        let propCount = tableData.properties.count
        for index in 0..<propCount {
            propertiesString += FMDBHelper.shared.string(tableProperty: tableData.properties[index])
            propertiesString += index < propCount - 1 ? " , \n" : ""
        }
        let executeString = "CREATE TABLE \(tableData.name) (\n" +
            "\(propertiesString) \n" +
        ");"
        return executeString
    }
    
    func dropTable(name: String) -> String {
        let executionString = "DROP TABLE \(name)"
        return executionString
    }
    
    func removeAttribute(tableName: String, attributeName: String) -> String {
        let table = DataManagerAPI.shared.getTable(dbFramework: .FMDB, name: tableName)
        let newTable = TableData(tableData: table, skipping: attributeName)
        let executionString = self.dropTable(name: tableName) + " ; \n" +
        self.tableCreation(tableData: newTable)
        return executionString
    }
    
    func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty) -> String {
        let table = DataManagerAPI.shared.getTable(dbFramework: .FMDB, name: tableName)
        let newTable = TableData(tableData: table, skipping: oldAttributeName)
        newTable.properties.append(attribute)
        let executionString = self.dropTable(name: tableName) + " ; \n" +
            self.tableCreation(tableData: newTable)
        return executionString
    }
    
    func addRecord(dbFramework: DataBaseFramework, tableName: String, record: Record) -> String {
        let table = DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: tableName)
        var columnsString = ""
        var valuesString = ""
        for (index, property) in table.properties.enumerated() {
            guard let value = record.valuesDict[property.name], property.name.characters.count > 0 else {
                return ""
            }
            let separatorString = index == table.properties.count - 1 ? "": ", "
            columnsString += property.name + separatorString
            valuesString += "\'\(value)\'" + separatorString
        }
        let executionString = "INSERT INTO \(table.name) VALUES (\(valuesString));" //*(\(columnsString))*/
        return executionString
    }
    
    func records(tableName: String) -> String {
        let executionString = "SELECT * FROM \(tableName)"
        return executionString
    }
    
}
