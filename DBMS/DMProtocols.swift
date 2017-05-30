//
//  RequestsDMProtocol.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Requests

protocol RequestsDMProtocol {
    
}

// MARK: Filling

protocol FillingReadDMProtocol {
    func tablesCount() -> Int
    func tablesNames() -> [String]
    func table(name: String) -> TableData
    func allTables() -> [TableData]
    func tableRecords(name: String) -> [Record]
}

protocol FillingWriteDMProtocol {
    func addRecord(tableName: String, record: Record, error: inout Error?)
}

// MARK: Editing

protocol EditingTableCreateDropDMProtocol {
    func createTable(tableData: TableData, error: inout Error?)
    func dropTable(name: String, error: inout Error?)
}

protocol EditingTableEditingDMProtocol {
    func renameTable(oldTableName: String, newTableName: String, error: inout Error?)
    func addAttribute(tableName: String, attribute: TableProperty, error: inout Error?)
    func removeAttribute(tableName: String, attributeName: String, error: inout Error?)
    func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty, error: inout Error?)
}

// MARK: references

protocol TablesReferencesManagerProtocol {
    func relationships(dbFramework: DataBaseFramework) -> [TablesRelationship]
    func addRelationship(dbFramework: DataBaseFramework, relationship: TablesRelationship)
    func removeRelationship(dbFramework: DataBaseFramework, relationship: TablesRelationship)
    func clearRelationships(dbFramework: DataBaseFramework)
}

// MARK: Requests

protocol RequestsManagerProtocol {
    func request(dbFramework: DataBaseFramework, name: String) -> RequestRealmObject
    func requests(dbFramework: DataBaseFramework) -> [RequestRealmObject]
    func addRequest(dbFramework: DataBaseFramework, request: RequestRealmObject)
    func clearRequests(dbFramework: DataBaseFramework)
    func removeRequest(request: RequestRealmObject)
    func updateSource(dbFramework: DataBaseFramework, request: RequestRealmObject, source: RequestSource)
    func updateSelectedAttributes(request: RequestRealmObject, attributes: [RequestSelectionItem])
    func addCondition(request: RequestRealmObject, conditionItem: RequestConditionItem)
    func conditionUpdateSelectionItem(conditionItem: RequestConditionItem, selectedItem: RequestSelectionItem)    
    func conditionUpdateType(conditionItem: RequestConditionItem, typeString: String)
    func conditionUpdateValue(conditionItem: RequestConditionItem, valueString: String)
    func removeConditionItem(request: RequestRealmObject, conditionItem: RequestConditionItem)
}
