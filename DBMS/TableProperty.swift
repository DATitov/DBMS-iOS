//
//  TableProperty.swift
//  DBMS
//
//  Created by Dmitrii Titov on 19.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import SQLite

enum DataType: String {
    case Int64 = "INTEGER"
    case Double = "REAL"
    case String = "TEXT"
    case None = ""
}

extension DataType {
    static func getTypeForString(string: String) -> DataType {
        switch string {
        case "INTEGER":
            return DataType.Int64
        case "REAL":
            return DataType.Double
        case "TEXT":
            return DataType.String
        default:
            return DataType.None
        }
    }
}

class TableProperty: NSObject {

    var name = ""
    var primaryKey = false
    var unique = false
    var nullable = true
        
    var type : DataType = .None
    
    var foreighKey: ForeignKey?
    
    override init() {
        super.init()
    }
    
    init(name : String, type : DataType) {
        super.init()
        self.name = name
        self.type = type
    }
    
}
