//
//  FMDBHelper.swift
//  DBMS
//
//  Created by Dmitrii Titov on 06.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = FMDBHelper()

class FMDBHelper: NSObject {
    
    class var shared : FMDBHelper {
        return sharedInstance
    }
    
    func dataType(fmdbFrameworkString: String) -> DataType {
        switch fmdbFrameworkString {
        case "TEXT":
            return .String
        case "INTEGER":
            return .Int64
        case "REAL":
            return .Double
        default:
            return .None
        }
    }
    
    func fmdbFrameworkString(dataType: DataType) -> String {
        switch dataType {
        case .String:
            return "TEXT"
        case .Int64:
            return "INTEGER"
        case .Double:
            return "REAL"
        default:
            return DataType.None.rawValue
        }
    }
    
    func string(tableProperty: TableProperty) -> String {
        var propertyString = ""
        propertyString += tableProperty.name + " "
        propertyString += self.fmdbFrameworkString(dataType: tableProperty.type) + " "
        propertyString += tableProperty.nullable ? "" : "NOT NULL "
        return propertyString
    }
    
}

