//
//  RequestExecutionManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 24.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RequestExecutionManager: NSObject {

    func tableData(dbFramework: DataBaseFramework, requestName: String) -> TableData {
        let request = DataManagerAPI.shared.request(dbFramework: dbFramework, name: requestName)
        if RequestRealmObject.isEmpty(request: request) {
            return DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: requestName)
        }
        let properties = { () -> [TableProperty] in 
            var properties = [TableProperty]()
            for selectedAttribute in request.selectionAttributes {
                var tableData = self.entityTableData(dbFramework: dbFramework, name: selectedAttribute.requestName)
                if TableData.isEmpty(tableData: tableData) {
                    tableData = self.tableData(dbFramework: dbFramework, requestName: selectedAttribute.requestName)
                }
                let property = tableData?.getProperty(name: selectedAttribute.attributeName)
                properties.append(property!)
            }
            return properties
        }()
        return TableData(name: requestName, properties: properties)
    }
    
    func entityTableData(dbFramework: DataBaseFramework, name: String) -> TableData? {
        let tableData = DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: name)
        if TableData.isEmpty(tableData: tableData) { return nil }
        return tableData
    }
    
    func records(dbFramework: DataBaseFramework, requestName: String) -> [Record] {
        var records = [Record]()
        let request = DataManagerAPI.shared.request(dbFramework: dbFramework, name: requestName)
        
        let rawRecords1 = self.rawTableRecords(dbFramework: dbFramework, tableName: request.source?.tableName1)
        let rawRecords2 = self.rawTableRecords(dbFramework: dbFramework, tableName: request.source?.tableName2)
        let rawRecords3 = self.rawRequestRecords(dbFramework: dbFramework, requestName: request.source?.requestName1)
        let rawRecords4 = self.rawRequestRecords(dbFramework: dbFramework, requestName: request.source?.requestName2)
        
        let tableData = self.tableData(dbFramework: dbFramework, requestName: requestName)
        records = self.mergeRecordsArrays(tableData: tableData, recordArray1: rawRecords1,
                                          recordArray2: rawRecords2,
                                          recordArray3: rawRecords3,
                                          recordArray4: rawRecords4)
        
        return records
    }
    
    fileprivate func mergeRecordsArrays(tableData: TableData,
                            recordArray1: [Record],
                            recordArray2: [Record],
                            recordArray3: [Record],
                            recordArray4: [Record]) -> [Record] {
        let maxCapacity = self.arraysMaxCapacity(arrays: [recordArray1, recordArray2, recordArray3, recordArray4])
        if maxCapacity < 1 { return [Record]() }
        let records1 = self.fillRecords(records: recordArray1, capacity: maxCapacity)
        let records2 = self.fillRecords(records: recordArray2, capacity: maxCapacity)
        let records3 = self.fillRecords(records: recordArray3, capacity: maxCapacity)
        let records4 = self.fillRecords(records: recordArray4, capacity: maxCapacity)
        
        var records = [Record]()
        
        for ((record1, record2), (record3, record4)) in zip(zip(records1, records2), zip(records3, records4)) {
            let record = Record(tableData: tableData)
            for localRecord in [record1, record2, record3, record4] {
                for key in localRecord.valuesDict.keys {
                    record.valuesDict[key] = localRecord.valuesDict[key]
                }
            }
            records.append(record)
        }
        
        return records
    }
    
    fileprivate func fillRecords(records: [Record], capacity: Int) -> [Record] {
        var newRecords = records
        let count = newRecords.count
        if count > 0 {
            let keys = records.first?.valuesDict.keys
            for _ in count..<capacity {
                let record = Record()
                for key in keys! {
                    record.valuesDict[key] = "nil"
                }
                newRecords.append(record)
            }
        }else{
            for _ in count...capacity {
                let record = Record()
                newRecords.append(record)
            }
        }
        return newRecords
    }
    
    fileprivate func arraysMaxCapacity(arrays: [[Any]]) -> Int {
        var maxCapacity = 0
        for array in arrays {
            if array.count > maxCapacity {
                maxCapacity = array.count
            }
        }
        return maxCapacity
    }
    
    fileprivate func rawTableRecords(dbFramework: DataBaseFramework, tableName: String?) -> [Record] {
        guard let name = tableName else {
            return [Record]()
        }
        if name.characters.count < 1 {
            return [Record]()
        }
        return DataManagerAPI.shared.getTableRecords(dbFramework: dbFramework, name: name)
    }
    
    fileprivate func rawRequestRecords(dbFramework: DataBaseFramework, requestName: String?) -> [Record] {
        guard let name = requestName else {
            return [Record]()
        }
        if name.characters.count < 1 {
            return [Record]()
        }
        return self.records(dbFramework: dbFramework, requestName: name)
    }
    
}
