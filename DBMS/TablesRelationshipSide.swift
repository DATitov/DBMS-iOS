//
//  TablesRelationshipSide.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift 

enum TablesRelationshipSideCount: String {
    case One = "One"
    case Many = "Many"
    case None = "None"
}

class TablesRelationshipSide: Object {
    
    dynamic var tableName = ""
    dynamic var propertyName = ""
    dynamic var count = TablesRelationshipSideCount.None.rawValue
    
    required init() {
        super.init()
    }    
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    var countTablesRelationshipSideCountEnum: TablesRelationshipSideCount {
        get {
            return TablesRelationshipSideCount(rawValue: count)!
        }
        set {
            count = newValue.rawValue
        }
    }
}

/*
 import ObjectMapper
 
class TablesRelationshipSideCountTransform: NSObject, TransformType {
    typealias Object = TablesRelationshipSideCount
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> Object? {
        // TODO: Test
        // Can fail on the following line
        let str = value as! String
        switch str {
        case "One":
            return .One
        case "Many":
            return .Many
        default:
            return TablesRelationshipSideCount.None
        }
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return ""
    }
 }
 
 required init?(map: Map) {
 
 }
 
 func mapping(map: Map) {
 tableName <- map["name"]
 count <- (map["count"], TablesRelationshipSideCountTransform())
 }
*/
