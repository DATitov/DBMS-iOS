//
//  RecordScreenswift
//  DBMS
//
//  Created by Dmitrii Titov on 13.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RecordScreenVM: NSObject {
    
    var dbFramework: DataBaseFramework = .None
    
    var tableData: TableData!
    var record: Record?
    
    init(dbFramework: DataBaseFramework, tableName: String, record: Record?) {
        self.tableData = DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: tableName)
        self.record = record
        self.dbFramework = dbFramework
    }
    
    func saveRecord(record: Record) {
        var error: Error?
        DataManagerAPI.shared.addRecord(dbFramework: dbFramework, tableName: tableData.name, record: record as! Record, error: &error)
        if error != nil {
            print(error ?? "")
        }
    }
    
}
