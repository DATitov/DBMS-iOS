//
//  DataBaseViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 01.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class DataBaseVM: NSObject {
    
    var dataBaseFramework : DataBaseFramework!
    
    init(dbFramework: DataBaseFramework) {
        super.init()
        dataBaseFramework = dbFramework
    }

}
