//
//  TablesRelationship.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

enum TablesRelationshipType: String {
    case ManyToOne = "ManyToOne"
    case OneToOne = "OneToOne"
    case OneToMany = "OneToMany"
}

class TablesRelationship: Object {
    
    dynamic var side1: TablesRelationshipSide? = nil
    dynamic var side2: TablesRelationshipSide? = nil
    
}
