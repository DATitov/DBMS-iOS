//
//  AppDBSchemaManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = AppDBSchemaManager()

class AppDBSchemaManager: NSObject {
        
    class var shared : AppDBSchemaManager {
        return sharedInstance
    }

}
