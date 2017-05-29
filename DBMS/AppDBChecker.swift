//
//  AppDBChecker.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = AppDBChecker()

class AppDBChecker: NSObject {
        
    class var shared : AppDBChecker {
        return sharedInstance
    }

    func checkTableExist(dbFramework: DataBaseFramework, name: String) -> Bool {
        let tableNames = DataManagerAPI.shared.getAllTablesNames(dbFramework: dbFramework)
        return tableNames.contains(name)
    }
    
}
