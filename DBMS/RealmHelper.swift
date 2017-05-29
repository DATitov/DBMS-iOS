//
//  RealmHelper.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class RLMString: Object {
    
    var str = ""
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    required init(string: String) {
        super.init()
        str = string
    }
    
}


class RealmHelper: NSObject {

}
