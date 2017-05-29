//
//  CoreDataHelper.swift
//  DBMS
//
//  Created by Dmitrii Titov on 09.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHelper: NSObject {
    
    func dataType(attributeType: NSAttributeType) -> DataType {
        switch attributeType {
        case .integer16AttributeType:
            return .Int64
        case .integer32AttributeType:
            return .Int64
        case .integer64AttributeType:
            return .Int64
        case .decimalAttributeType:
            return .Int64
        case .floatAttributeType:
            return .Double
        case .doubleAttributeType:
            return .Double
        case .stringAttributeType:
            return .String
        default:
            return .None
        }
    }

}

extension TableData {
    
    convenience init(coreDataEntity: NSEntityDescription) {
        self.init()
        name = coreDataEntity.name!
        properties = coreDataEntity.properties.filter({ $0.isMember(of: NSAttributeDescription.self) })
            .map({ TableProperty(coreDataProperty: $0 as! NSAttributeDescription) })
    }
    
    func coreDataEntityDescription() -> NSEntityDescription {
        let entity = NSEntityDescription()
        entity.name = name
        var properties = [NSPropertyDescription]()
        for attribute in self.properties {
            properties.append(attribute.coreDataPropertyDescription())
        }
        entity.properties = properties
        return entity
    }
}

extension TableProperty {
    
    convenience init(coreDataProperty: NSAttributeDescription) {
        self.init()
        name = coreDataProperty.name
        type = CoreDataHelper().dataType(attributeType: coreDataProperty.attributeType)
    }
    
    func coreDataPropertyDescription() -> NSPropertyDescription {
        let property = NSAttributeDescription()
        property.name = name
        property.attributeType = .stringAttributeType
        property.isOptional = nullable
        return property
    }
    
}
