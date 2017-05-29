//
//  FileSystemProperty.swift
//  DBMS
//
//  Created by Дмитрий on 10.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class FileSystemProperty: NSObject, Mappable {
    
    var name = ""
    var type: DataType = .None

    init(tableProperty: TableProperty) {
        //super.init()
        name = tableProperty.name
        type = tableProperty.type
    }
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        name <- map["name"]
        type <- map["type"]
    }
    
    func mapping(map: Map) {
        
    }
    
    func toJSONString() -> String! {
        return "\"name\":\"\(name)\",\"type\":\"\(type.rawValue)\""
        //return "\"name\":\"\(name)\",\"type\":\"\type\""
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
