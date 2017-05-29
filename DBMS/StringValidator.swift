//
//  StringValidator.swift
//  DBMS
//
//  Created by Dmitrii Titov on 14.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class StringValidator: NSObject {    
    
    func float(string: String) -> Bool {
        let pattern = "^([0-9]+)?(\\.([0-9]{1,2})?)?$"
        let test = NSPredicate(format: "SELF MATCHES %@", pattern)
        let res = test.evaluate(with: string)
        return res
    }
    
    func int(string: String) -> Bool {
        let pattern = "^[+-]?[1-9]*"
        let test = NSPredicate(format: "SELF MATCHES %@", pattern)
        let res = test.evaluate(with: string)
        return res
    }
    
}
