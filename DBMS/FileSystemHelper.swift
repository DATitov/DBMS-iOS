//
//  FileSystemHelper.swift
//  DBMS
//
//  Created by Dmitrii Titov on 10.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let sharedInstance = FileSystemHelper()


class FileSystemHelper: NSObject {
    
    class var shared : FileSystemHelper {
        return sharedInstance
    }

    let encoding = String.Encoding.utf8
    
    func jsonRecord(tableData: TableData, record: Record) -> String {
        var pairsString = ""
        for (index, propertyName) in tableData.properties.map({ $0.name }).enumerated() {
            let pairString = "\"\(propertyName)\":\"\(record.valuesDict[propertyName]!)\""
            pairsString += pairString + (index == tableData.properties.count - 1 ? "": ",")
        }
        return "{\(pairsString)}"
    }
    
    
    
}

extension TableData {
    
    convenience init(fileSystemEntity: FileSystemEntity) {
        self.init()
        name = fileSystemEntity.name
        for prprt in fileSystemEntity.properties {
            properties.append(TableProperty(fileSystemProperty: prprt))
        }
    }
    
}

extension TableProperty {
    
    convenience init(fileSystemProperty: FileSystemProperty) {
        self.init()
        name = fileSystemProperty.name
        type = DataType.Double//fileSystemProperty.type
    }
    
}

