//
//  DataBasesManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 16.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

enum DataBaseFramework: String {
    case SQLite = "SQLite"
    case FMDB = "FMDB"
    case CoreData = "Core Data"
    case FileSystem = "File System"
    case None = "None"
}

private let sharedInstance = DataBasesManager()

class DataBasesManager: NSObject {
    
    class var shared : DataBasesManager {
        return sharedInstance
    }
    
    func dataBasesTypesAvailable() -> [DataBaseFramework] {
        return DBInfoStorageJSONSerialiser.shared.dbFrameworksAvailable()
    }
    
    func dataBaseInfo(dbFramework: DataBaseFramework) -> DBInfoStorage {
        return DBInfoStorage(dbFramework: dbFramework)
    }
    
    func dataBaseFramework(name: String) -> DataBaseFramework {
        if name == DataBaseFramework.SQLite.rawValue { return .SQLite }
        if name == DataBaseFramework.CoreData.rawValue { return .SQLite }
        if name == DataBaseFramework.FileSystem.rawValue { return .SQLite }
        return .None
    }
    
    func dataBaseEditingEnabled(dbFramework: DataBaseFramework) -> Bool{
        return DBInfoStorageJSONSerialiser.shared.dataBaseEditingEnabled(dbFramework: dbFramework)
    }
}
