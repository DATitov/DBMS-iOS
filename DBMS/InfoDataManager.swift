//
//  InfoDataManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = InfoDataManager()

class InfoDataManager: NSObject {
    
    class var shared : InfoDataManager {
        return sharedInstance
    }
}
