//
//  DBInfoStorage.swift
//  DBMS
//
//  Created by Dmitrii Titov on 16.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class DBInfoStorage: NSObject {

    var name = ""
    var editingEnabled : Bool = false
    var type : DataBaseFramework = .None
    
    init(dbFramework: DataBaseFramework) {
        super.init()
        type = dbFramework
        
        self.initParams()
    }
    
    func initParams() {
        let dict = self.getInfoDict()
        if dict.keys.count < 1 {
            return
        }
    }
    
    func getInfoDict() -> Dictionary<String, Any> {
        let path = Bundle.main.path(forResource: "DataBasesInfoStorage", ofType: "json")
        let jsonData = (try? Data(contentsOf: URL(fileURLWithPath: path!)))!
        let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as! Dictionary<String, Any>
        //let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! Dictionary<String, Any>
        let dbInfoArrays = jsonObject?["frameworks_info"] as! [Dictionary<String, AnyObject>]
        for dbInfoDict in dbInfoArrays {
            //if dbInfoDict["dbFramework"] as! String == type.rawValue {
                return dbInfoDict
            //}
            
        }
        return Dictionary<String, Any>()
    }
    
}
