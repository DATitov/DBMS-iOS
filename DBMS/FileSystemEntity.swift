//
//  FileSystemEntity.swift
//  DBMS
//
//  Created by Dmitrii Titov on 10.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class FileSystemEntity: NSObject, Mappable {

    var name = ""
    var properties = [FileSystemProperty]()
    
    
    init(tableData: TableData) {
        super.init()
        name = tableData.name
        properties = [FileSystemProperty]()
        for prprt in tableData.properties {
            properties.append(FileSystemProperty(tableProperty: prprt))
        }
    }
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        properties <- map["properties"]
    }
    
    func toJSONString() -> String! {
        var propertiesJSONText = ""
        for index in 0..<properties.count {
            propertiesJSONText += "{" + properties[index].toJSONString() + "}"
            propertiesJSONText += index == properties.count - 1 ? "" : ","
        }
        return "{\"name\":\"\(name)\",\"properties\":[\(propertiesJSONText)]}"
    }
    
    /*
    override init() {
        super.init()
    }
    
    required init(data: Data!) throws {
        try super.init(data: data)
    }
    
    required init(dictionary dict: [AnyHashable : Any]!) throws {
        try super.init(dictionary: dict)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(string: String, error: AutoreleasingUnsafeMutablePointer<JSONModelError?>!) {
        super.init(string: string, error: error)
    }
    
    override init!(string: String!, usingEncoding encoding: UInt, error err: AutoreleasingUnsafeMutablePointer<JSONModelError?>!) {
        super.init(string: string, usingEncoding: encoding, error: err)
    }
    */
}
