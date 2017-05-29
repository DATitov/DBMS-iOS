//
//  Record.swift
//  DBMS
//
//  Created by Александр Кузяев 2 on 21/03/17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import ObjectMapper

class RecordTransform: NSObject, TransformType {
    typealias Object = [String: String]
    typealias JSON = String

    func transformFromJSON(_ value: Any?) -> Object? {
        var dict = [String: String]()
        for array in value as! [[String: AnyObject]] {
            for (key, value) in array {
                dict[key] = "\(value)"
            }
        }

        return dict
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        return ""
    }
}


class Record: NSObject, Mappable {
    
    var valuesDict: [String: String] = [String: String]()
    
    override init() {
        super.init()
    }
    
    init(tableData: TableData) {
        super.init()
        self.createValuesDict(tableData:tableData)
    }
    
    required init?(map: Map) {
        
    }
    
    func createValuesDict(tableData: TableData) {
        valuesDict = [String: String]()
        for property in tableData.properties {
            valuesDict[property.name] = ""
        }
    }
    
    func mapping(map: Map) {
        valuesDict <- (map["values"], RecordTransform())
    }
    
    func toJSONString(tableData: TableData) -> String {
        var propertiesJSONText = ""
        for (index, property) in tableData.properties.enumerated() {
            guard let value = valuesDict[property.name] else {
                return "{}"
            }
            propertiesJSONText += "{\"\(property.name)\":\"\(value)\"}"
            propertiesJSONText += index == tableData.properties.count - 1 ? "" : ","
        }
        let jsonString = "{\"values\":[\(propertiesJSONText)]}"
        return jsonString
    }
    
    func stringValue(key: String) -> String {
        return valuesDict[key]!
    }
    
    func intValue(key: String) -> Int64 {
        let value = valuesDict[key]
        guard let number = NumberFormatter().number(from: value!) else {
            return 0
        }
        return number.int64Value
    }
    
    func floatValue(key: String) -> CGFloat {
        let value = valuesDict[key]
        guard let number = NumberFormatter().number(from: value!) else {
            return 0
        }
        return CGFloat(number.floatValue)
    }
    
}
