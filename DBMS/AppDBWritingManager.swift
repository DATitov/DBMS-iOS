//
//  AppDBWritingManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = AppDBWritingManager()

class AppDBWritingManager: NSObject {
        
    class var shared : AppDBWritingManager {
        return sharedInstance
    }

}
