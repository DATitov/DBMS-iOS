//
//  DataTypeSelectionCellViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 05.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class DataTypeSelectionCellVM: NSObject {

    
    let dataTypeVariable = Variable<DataType>(.None)
    
    init(dataType: DataType) {
        super.init()
        self.dataTypeVariable.value = dataType
    }
    
    func dataType(index: Int) -> DataType {
        switch index {
        case 0:
            return .Int64
        case 1:
            return .Double
        case 2:
            return .String
        default:
            return .None
        }
    }
    
    func dataTypeString(index: Int) -> String {
        return self.dataType(index: index).rawValue
    }
    
    func dataTypesCount() -> Int {
        return 3
    }
    
    func index(dataType: DataType) -> Int {
        for index in 0..<self.dataTypesCount() {
            if self.dataType(index: index) == dataType {
                return index
            }
        }
        return 0
    }
    
}
