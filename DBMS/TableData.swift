//
//  Table.swift
//  DBMS
//
//  Created by Dmitrii Titov on 19.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class TableData: NSObject {

    var name = ""
    var properties = [TableProperty]()
    
    override init() {
        super.init()
    }
    
    init(name : String, properties : [TableProperty]) {
        self.name = name
        self.properties = properties
    }
    
    init(tableData: TableData, skipping propertyName: String) {
        self.name = tableData.name
        for property in tableData.properties {
            if property.name.uppercased() != propertyName.uppercased() {
                properties.append(property)
            }
        }
    }
    
    func getProperty(name: String) -> TableProperty? {
        for prprt in properties {
            if prprt.name == name{
                return prprt
            }
        }
        return nil
    }
    
    func propertyExist(propertyName: String) -> Bool {
        for property in properties {
            if property.name == propertyName {
                return true
            }
        }
        return false
    }
    
    static func isEmpty(tableData: TableData?) -> Bool {
        if tableData == nil { return true }
        return tableData!.name.characters.count < 1 || (tableData?.properties.count)! < 1
    }
}
