//
//  RequestRealmObject.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class RequestRealmObject: Object {
    
    dynamic var name = ""
    var selectionAttributes = List<RequestSelectionItem>()
    dynamic var source: RequestSource?
    var conditionItems = List<RequestConditionItem>()
    
    init(tableData: TableData) {
        super.init()
        name = tableData.name
        source = {
            let source = RequestSource()
            source.tableName1 = tableData.name
            return source
        }()
        selectionAttributes = {
            let list = List<RequestSelectionItem>()
            for name in tableData.properties.map({ RequestSelectionItem(requestName: tableData.name, attributeName: $0.name) }) {
                list.append(name)
            }
            return list
        }()
        
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
    
    override class func primaryKey() -> String? {
        return "name"
    }
    
    static func isEmpty(request: RequestRealmObject?) -> Bool {
        if request == nil { return true }
        return request!.name.characters.count < 1
    }
        
}
