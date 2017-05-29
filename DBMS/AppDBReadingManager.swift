//
//  AppDBReadingManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = AppDBReadingManager()

fileprivate let GROUPS_TABLE_NAME = "tables_groups"

class AppDBReadingManager: NSObject {
        
    class var shared : AppDBReadingManager {
        return sharedInstance
    }
    
    func getTable(dbFramework: DataBaseFramework, name : String) -> TableData {
        return DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: name)
    }
    
    func getAllTables(dbFramework: DataBaseFramework) -> [TableData] {
        return DataManagerAPI.shared.getAllTables(dbFramework: dbFramework)
    }
    
    func getAllTablesNames(dbFramework: DataBaseFramework) -> [String] {
        return DataManagerAPI.shared.getAllTablesNames(dbFramework: dbFramework)
    }
    
}
