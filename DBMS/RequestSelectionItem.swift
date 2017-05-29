//
//  RequestSelectionItem.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RequestSelectionItem: Object {
    
    dynamic var requestName = ""
    dynamic var attributeName = ""
    
    init(requestName: String, attributeName: String) {
        super.init()
        self.requestName = requestName
        self.attributeName = attributeName
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
    
}
