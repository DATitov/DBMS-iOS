//
//  RecordScreenViewModel.swift
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
    
}
