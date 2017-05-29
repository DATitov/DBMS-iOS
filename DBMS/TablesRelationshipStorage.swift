//
//  TablesRelationshipStorage.swift
//  DBMS
//
//  Created by Dmitrii Titov on 16.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class TablesRelationshipStorage: Object {
    
    dynamic var dbFramework = DataBaseFramework.None.rawValue
    var relationships = List<TablesRelationship>()
    
    required init() {
        super.init()
    }
    
    init(dbFramework: DataBaseFramework) {
        super.init()
        dbFrameworkEnum = dbFramework
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
        
    var dbFrameworkEnum: DataBaseFramework {
        get {
            return DataBaseFramework(rawValue: dbFramework)!
        }
        set {
            dbFramework = newValue.rawValue
        }
    }
}
