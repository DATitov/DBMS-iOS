//
//  Element.swift
//  DBMS
//
//  Created by Александр Кузяев 2 on 21/03/17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation

class Element {
    var property: TableProperty!
    
    func getValueString() -> String {
        if let elementInt = self as? ElementInt {
            return "\(elementInt.value!)"
        } else if let elementDouble = self as? ElementDouble {
            return "\(elementDouble.value!)"
        } else if let elementString = self as? ElementString {
            return "\(elementString.value!)"
        }
        return ""
    }
}

class ElementInt: Element {
    var value: Int64!
    
    init(property: TableProperty, value: Int64) {
        super.init()
        self.property = property
        self.value = value
    }
}

class ElementDouble: Element {
    var value: Double!
    
    init(property: TableProperty, value: Double) {
        super.init()
        self.property = property
        self.value = value
    }
}

class ElementString: Element {
    var value: String!
    
    init(property: TableProperty, value: String) {
        super.init()
        self.property = property
        self.value = value
    }
}

class ElementBool: Element {
    var value: Bool!
    
    init(property: TableProperty, value: Bool) {
        super.init()
        self.property = property
        self.value = value
    }
}
