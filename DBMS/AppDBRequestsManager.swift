//
//  AppDBRequestsManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = AppDBRequestsManager()

class AppDBRequestsManager: NSObject {
        
    class var shared : AppDBRequestsManager {
        return sharedInstance
    }

}
