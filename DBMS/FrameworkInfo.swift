//
//  FrameworkInfo.swift
//  DBMS
//
//  Created by Dmitrii Titov on 06.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class FrameworkInfo: Mappable {

    var dbFramework: DataBaseFramework?
    var editingAvailable: Bool?
    var primaryKeyAvailable: Bool?
    var uniqueKeyAvailable: Bool?
    var nullableAvailable: Bool?
    var emptyTableAvailable: Bool?
  
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        dbFramework <- map["data_base_framework"]
        editingAvailable <- map["editing_enabled"]
        uniqueKeyAvailable <- map["unique_available"]
        nullableAvailable <- map["nullable_available"]
        primaryKeyAvailable <- map["primary_key_available"]
        emptyTableAvailable <- map["empty_table_available"]
    }
    
    /*
    override init() {
        super.init()
    }
    
    required init(dictionary dict: [AnyHashable : Any]!) throws {
        try super.init(dictionary: dict)
        let dbFrameworkString = dict[AnyHashable("data_base_framework")] as! String
        dbFramework = DataBaseFramework(rawValue: dbFrameworkString)!
    }
    
    required init(data: Data!) throws {
        try super.init(data: data)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func keyMapper() -> JSONKeyMapper! {
        return JSONKeyMapper(modelToJSONDictionary: ["dbFramework" : "data_base_framework",
                                                     "editingAvailable" : "editing_enabled",
                                                     "uniqueKeyAvailable" : "unique_available",
                                                     "nullableAvailable" : "nullable_available",
                                                     "primaryKeyAvailable" : "primary_key_available"])
    }
    
    func propertyIsOptional(_ propertyName: String!) -> Bool {
        return false
    }
    */
}
