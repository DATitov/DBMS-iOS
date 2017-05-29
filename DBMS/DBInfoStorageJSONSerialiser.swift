//
//  DBInfoStorageJSONSerialiser.swift
//  DBMS
//
//  Created by Dmitrii Titov on 16.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = DBInfoStorageJSONSerialiser()

fileprivate let FRAMEWORKS_AVAILABLE_k = "frameworks_available"
fileprivate let FRAMEWORK_EDITING_ENABLED_k = "editing_enabled"
fileprivate let FRAMEWORKS_INFO_k = "frameworks_info"
fileprivate let FRAMEWORKS_NAME_k = "data_base_framework"
fileprivate let FRAMEWORKS_UNIQUE_AVAILABLE_k = "unique_available"
fileprivate let FRAMEWORKS_NULLABLE_AVAILABLE_k = "nullable_available"
fileprivate let FRAMEWORKS_PRIMARY_KEY_AVAILABLE_k = "primary_key_available"
fileprivate let SOURCE_FILE_NAME = "DataBasesInfoStorage"

class DBInfoStorageJSONSerialiser: NSObject {
    
    class var shared : DBInfoStorageJSONSerialiser {
        return sharedInstance
    }
    
    func dbFrameworksAvailable() -> [DataBaseFramework] {
        let dict = self.jsonObject()
        let typesDictArray = dict[FRAMEWORKS_AVAILABLE_k] as! [Dictionary<String, String>]
        var types = [DataBaseFramework]()
        for typeNameDict in typesDictArray {
            types.append(DataBaseFramework(rawValue: typeNameDict[FRAMEWORKS_NAME_k]! as String)!)
        }
        return types
    }
    
    func dataBaseEditingEnabled(dbFramework: DataBaseFramework) -> Bool {
        let obj = self.jsonObject() as Dictionary<String, Any>
        let dataBases = obj[FRAMEWORKS_INFO_k] as! [Dictionary<String, Any>]
        for infoDict in dataBases {
            let name = infoDict[FRAMEWORKS_NAME_k]! as! String
            if name == dbFramework.rawValue {
                let editingEnabled = infoDict[FRAMEWORK_EDITING_ENABLED_k] as! Bool
                return editingEnabled
            }
        }
        return false
    }
    
    fileprivate func jsonObject() -> Dictionary<String, Any> {
        let path = Bundle.main.path(forResource: SOURCE_FILE_NAME, ofType: "json")
        let jsonData = (try? Data(contentsOf: URL(fileURLWithPath: path!)))!
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Dictionary<String, Any>
        return jsonObject!
    }
    
}
