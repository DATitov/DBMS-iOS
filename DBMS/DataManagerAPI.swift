//
//  DataManagerAPI.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

enum DataManagerAPIError: Error {
    case NoObjectFounded
    case NotValid
    case CanNotConnectToDB
    case FrameworkExecutionFailure
    case Other
}

class DataManagerAPI: NSObject {
    
    static let shared: DataManagerAPI = {
        let instance = DataManagerAPI()
        return instance
    }()
    
    fileprivate let connector = DBFrameworkInteractorConnecter()
    let requestExecutionManager = RequestExecutionManager()
    
    // MARK: Schemas
    
    func getTable(dbFramework: DataBaseFramework, name : String) -> TableData {
        return connector.interactor(dbFramework: dbFramework).table(name: name)
    }
    
    func getAllTables(dbFramework: DataBaseFramework) -> [TableData] {
        return connector.interactor(dbFramework: dbFramework).allTables()
    }
    
    func getAllTablesNames(dbFramework: DataBaseFramework) -> [String] {
        return connector.interactor(dbFramework: dbFramework).tablesNames()
    }    
    
    func addColumn(dbFramework: DataBaseFramework, tableName: String, attribute: TableProperty, error: inout Error?) {
        connector.interactor(dbFramework: dbFramework).addAttribute(tableName: tableName, attribute: attribute, error: &error)
        connector.requestsManager.clearRequests(dbFramework: dbFramework)
    }
    
    func removeColumn(dbFramework: DataBaseFramework, tableName: String, columnName: String, error: inout Error?) {
        connector.interactor(dbFramework: dbFramework).removeAttribute(tableName: tableName, attributeName: columnName, error: &error)
        connector.requestsManager.clearRequests(dbFramework: dbFramework)
    }
    
    func createTable(dbFramework: DataBaseFramework, table : TableData, error: inout Error?) {
        connector.interactor(dbFramework: dbFramework).createTable(tableData: table, error: &error)
        connector.requestsManager.clearRequests(dbFramework: dbFramework)
    }
    
    func dropTable(dbFramework: DataBaseFramework, name: String, error: inout Error?) {
        return connector.interactor(dbFramework: dbFramework).dropTable(name: name, error: &error)
        connector.requestsManager.clearRequests(dbFramework: dbFramework)
    }
    
    func renameTable(dbFramework: DataBaseFramework, oldTableName: String, newTableName: String, error: inout Error?) {
        connector.interactor(dbFramework: dbFramework).renameTable(oldTableName: oldTableName, newTableName: newTableName, error: &error)
        connector.requestsManager.clearRequests(dbFramework: dbFramework)
    }
    
    func updateAttribute(dbFramework: DataBaseFramework, tableName: String, oldAttributeName: String, attribute: TableProperty, error: inout Error?) {
        connector.interactor(dbFramework: dbFramework).updateAttribute(tableName: tableName, oldAttributeName: oldAttributeName, attribute: attribute, error: &error)
        connector.requestsManager.clearRequests(dbFramework: dbFramework)
    }
    
    // MARK: Records
    
    func getTableRecords(dbFramework: DataBaseFramework, name: String) -> [Record] {
        return connector.interactor(dbFramework: dbFramework).tableRecords(name: name)
    }
    
    func addRecord(dbFramework: DataBaseFramework, tableName: String, record: Record, error: inout Error?) {
        return connector.interactor(dbFramework: dbFramework).addRecord(tableName: tableName, record: record, error: &error)
    }
    
    // MARK: References
    
    func references(dbFramework: DataBaseFramework) -> [TablesRelationship] {
        return connector.relationshipsManager.references(dbFramework: dbFramework)
    }
    
    func addRelationship(dbFramework: DataBaseFramework, relationship: TablesRelationship) {
        connector.relationshipsManager.addRelationship(dbFramework: dbFramework, relationship: relationship)
    }
    
    func removeRelationship(dbFramework: DataBaseFramework, relationship: TablesRelationship) {
        connector.relationshipsManager.removeRelationship(dbFramework: dbFramework, relationship: relationship)
    }
    
    // MARK: Requests
    
    func request(dbFramework: DataBaseFramework, name: String) -> RequestRealmObject {
        return connector.requestsManager.request(dbFramework: dbFramework, name: name)
    }
    
    func requests(dbFramework: DataBaseFramework) -> [RequestRealmObject] {
        return connector.requestsManager.requests(dbFramework: dbFramework)
    }
    
    func addRequest(dbFramework: DataBaseFramework, request: RequestRealmObject) {
        connector.requestsManager.addRequest(dbFramework: dbFramework, request: request)
    }
    
    func removeRequest(request: RequestRealmObject) {
        connector.requestsManager.removeRequest(request: request)
    }
    
    func updateSource(dbFramework: DataBaseFramework, request: RequestRealmObject, source: RequestSource) {
        connector.requestsManager.updateSource(dbFramework: dbFramework, request: request, source: source)
    }
    
    func updateSelectedAttributes(request: RequestRealmObject, attributes: [RequestSelectionItem]) {
        connector.requestsManager.updateSelectedAttributes(request: request, attributes: attributes)
    }
    
    func addCondition(request: RequestRealmObject, conditionItem: RequestConditionItem) {
        connector.requestsManager.addCondition(request: request, conditionItem: conditionItem)
    }
    
    func conditionUpdateSelectionItem(conditionItem: RequestConditionItem, selectedItem: RequestSelectionItem) {
        connector.requestsManager.conditionUpdateSelectionItem(conditionItem: conditionItem, selectedItem: selectedItem)
    }
    
    func conditionUpdateType(conditionItem: RequestConditionItem, typeString: String) {
        connector.requestsManager.conditionUpdateType(conditionItem: conditionItem, typeString: typeString)
    }
    
    func conditionUpdateValue(conditionItem: RequestConditionItem, valueString: String) {
        connector.requestsManager.conditionUpdateValue(conditionItem: conditionItem, valueString: valueString)
    }
    
    func removeConditionItem(request: RequestRealmObject, conditionItem: RequestConditionItem) {
        connector.requestsManager.removeConditionItem(request: request, conditionItem: conditionItem)
    }
    
}
