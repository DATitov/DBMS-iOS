//
//  RequestConditionItem.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import RealmSwift

enum RequestConditionType: String {
    case Less = "<"
    case Equal = "="
    case More = ">"
}

class RequestConditionItem: Object {
    
    dynamic var selectedItem: RequestSelectionItem?
    dynamic var type = ""
    dynamic var value = ""
    
    var typeEnum: RequestConditionType {
        get {
            return RequestConditionType(rawValue: type)!
        }
        set {
            type = newValue.rawValue
        }
    }
    
}
