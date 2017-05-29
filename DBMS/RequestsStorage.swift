//
//  RequestsStorage.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RequestsStorage: Object {
    
    dynamic var dbFramework = DataBaseFramework.None.rawValue
    var requests = List<RequestRealmObject>()
    
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
    
    required init() {
        super.init()
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
