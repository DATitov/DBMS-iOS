//
//  FillTableViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 12.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RecordPresentationModel: NSObject {
    var values = [String]()
    
    override init() {
        super.init()
    }
    
    init(tableData: TableData, record: Record) {
        super.init()
        for property in tableData.properties {
            guard let value = record.valuesDict[property.name] else {
                return
            }
            values.append(value)
        }
    }
}

class FillTableVM: NSObject {

    var dbFramework: DataBaseFramework = .None
    var table = TableData(name: "Empty", properties: [])
    
    var recordsModels = [RecordPresentationModel]()
    
    init(dbFramework: DataBaseFramework, tableName: String) {
        super.init()
        self.dbFramework = dbFramework
        table = DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: tableName)
        self.relaunch()
    }
    
    func relaunch() {
        recordsModels = DataManagerAPI.shared.getTableRecords(dbFramework: dbFramework, name: table.name).map({ RecordPresentationModel(tableData: self.table, record: $0) })
    }
    
    func numberOfRecords() -> Int {
        return recordsModels.count
    }
    
    func recordModel(forIndex index: Int) -> RecordPresentationModel {
        guard index < recordsModels.count else {
            return RecordPresentationModel()
        }
        return recordsModels[index]
    }
    
}
