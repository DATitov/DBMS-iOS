//
//  RequestSource.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import RealmSwift

class RequestSource: Object {
    
    dynamic var tableName1: String?
    dynamic var tableName2: String?
    
    dynamic var requestName1: String?
    dynamic var requestName2: String?
    
}
