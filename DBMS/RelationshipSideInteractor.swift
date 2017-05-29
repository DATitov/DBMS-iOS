//
//  RelationshipSideViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RelationshipSideVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    let tableData = Variable<TableData>(TableData())
    let tableProperty = Variable<TableProperty>(TableProperty())
    
    let availableTables = Variable<[TableData]>([TableData]())
    let availableProperties = Variable<[TableProperty]>([TableProperty]())
    
    let selectedTable = Variable<TableData>(TableData())
    let selectedProperty = Variable<TableProperty>(TableProperty())
    
    init(relationshipSide: TablesRelationshipSide?) {
        super.init()
        self.initBindings()
    }
    
    func initBindings() {
        
    }
    
    func tableName(forIndex index: Int) -> String? {
        guard availableTables.value.count > index else {
            return nil
        }
        return availableTables.value[index].name
    }
    
    func tablePropertyName(forIndex index: Int) -> String? {
        guard availableProperties.value.count > index else {
            return nil
        }
        return availableProperties.value[index].name
    }
    
    func didSelectTable(atIndex index: Int) {
        guard availableTables.value.count > index else {
            return
        }
        selectedTable.value = availableTables.value[index]
    }
    
    func didSelectProprty(atIndex index: Int) {
        guard availableProperties.value.count > index else {
            return
        }
        selectedProperty.value = availableProperties.value[index]
    }
    
}
