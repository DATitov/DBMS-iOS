//
//  FileSystemRecordsFileContent.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class FileSystemRecordsFileContent: NSObject, Mappable {

    var records: [Record]!
    
    override init() {
        super.init()
    }
    
    required init?(map: Map) {
        records <- map["records"]    
    }
    
    func mapping(map: Map) {
        
    }
    
}
