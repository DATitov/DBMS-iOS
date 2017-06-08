//
//  RelationshipViewViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RelationshipViewVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    var relationship: TablesRelationship
    
    var tables = [TableData]()
    
    let table1 = Variable<TableData>(TableData())
    let table2 = Variable<TableData>(TableData())
    let property1 = Variable<TableProperty>(TableProperty())
    let property2 = Variable<TableProperty>(TableProperty())
    let dataType = Variable<DataType>(DataType.None)
    let relationshipType = Variable<TablesRelationshipType>(TablesRelationshipType.OneToOne)
    
    var dbFramework = DataBaseFramework.None
    
    var relationshipSide1ViewModel: RelationshipSideVM!
    var relationshipSide2ViewModel: RelationshipSideVM!
    var relationshipTypeViewViewModel = TablesRelationshipTypeViewVM()
    
    init(dbFramework: DataBaseFramework, relationship: TablesRelationship?) {
        self.relationship = relationship ?? TablesRelationship()
        self.dbFramework = dbFramework
        super.init()
        relationshipSide1ViewModel = RelationshipSideVM(relationshipSide: relationship?.side1)
        relationshipSide2ViewModel = RelationshipSideVM(relationshipSide: relationship?.side2)
        self.createTables()
        self.initBindings()
        
        if relationshipSide1ViewModel.availableTables.value.count > 0 {
            relationshipSide1ViewModel.selectedTable.value = relationshipSide1ViewModel.availableTables.value[0]
        }
        if relationshipSide1ViewModel.availableProperties.value.count > 0 {
            relationshipSide1ViewModel.selectedProperty.value = relationshipSide1ViewModel.availableProperties.value[0]
        }
        if relationshipSide2ViewModel.availableTables.value.count > 0 {
            relationshipSide2ViewModel.selectedTable.value = relationshipSide2ViewModel.availableTables.value[0]
        }
        if relationshipSide2ViewModel.availableProperties.value.count > 0 {
            relationshipSide2ViewModel.selectedProperty.value = relationshipSide2ViewModel.availableProperties.value[0]
        }
    }
    
    func createTables() {
        tables = DataManagerAPI.shared.getAllTables(dbFramework: dbFramework)
    }
    
    func initBindings() {
        
        _ = table1.asObservable()
            .distinctUntilChanged()
            .map({ (tableData) -> [TableData] in
                return self.tables.filter({ $0.name != tableData.name && $0.properties.count > 0})
            })
            .bindTo(self.relationshipSide2ViewModel.availableTables)
            .disposed(by: disposeBag)
        
        _ = table2.asObservable()
            .distinctUntilChanged()
            .map({ (tableData) -> [TableData] in
                return self.tables.filter({ $0.name != tableData.name && $0.properties.count > 0})
            })
            .bindTo(self.relationshipSide1ViewModel.availableTables)
            .disposed(by: disposeBag)
        
        _ = table1.asObservable()
            .distinctUntilChanged()
            .map({ (tableData) -> [TableProperty] in
                return tableData.properties
            })
            .bindTo(self.relationshipSide1ViewModel.availableProperties)
            .disposed(by: disposeBag)
        
        _ = table2.asObservable()
            .distinctUntilChanged()
            .map({ (tableData) -> [TableProperty] in
                return tableData.properties
            })
            .bindTo(self.relationshipSide2ViewModel.availableProperties)
            .disposed(by: disposeBag)
        
        _ = relationshipSide1ViewModel.selectedTable.asObservable()
            .bindTo(self.table1)
            .disposed(by: disposeBag)
        
        _ = relationshipSide2ViewModel.selectedTable.asObservable()
            .bindTo(self.table2)
            .disposed(by: disposeBag)
        
        _ = relationshipSide1ViewModel.selectedProperty.asObservable()
            .bindTo(self.property1)
            .disposed(by: disposeBag)
        
        _ = relationshipSide2ViewModel.selectedProperty.asObservable()
            .bindTo(self.property2)
            .disposed(by: disposeBag)
        
        _ = table1.asObservable()
            .map({ $0.name })
            .bindTo(self.relationshipTypeViewViewModel.side1TableName)
            .disposed(by: disposeBag)
        
        _ = table2.asObservable()
            .map({ $0.name })
            .bindTo(self.relationshipTypeViewViewModel.side2TableName)
            .disposed(by: disposeBag)
        
        _ = property1.asObservable()
            .map({ $0.name })
            .bindTo(self.relationshipTypeViewViewModel.side1PropertyName)
            .disposed(by: disposeBag)
        
        _ = property2.asObservable()
            .map({ $0.name })
            .bindTo(self.relationshipTypeViewViewModel.side2PropertyName)
            .disposed(by: disposeBag)
    }
    
    func constructRelationship() -> TablesRelationship {
        let relationship = TablesRelationship()
        let side1 = TablesRelationshipSide()
        let side2 = TablesRelationshipSide()
        side1.tableName = table1.value.name
        side2.tableName = table2.value.name
        side1.propertyName = property1.value.name
        side2.propertyName = property2.value.name
        relationship.side1 = side1
        relationship.side2 = side2
        
        switch relationshipTypeViewViewModel.relationshipType {
        case .ManyToOne:
            side1.countTablesRelationshipSideCountEnum = .Many
            side2.countTablesRelationshipSideCountEnum = .One
            break
        case .OneToOne:
            side1.countTablesRelationshipSideCountEnum = .One
            side2.countTablesRelationshipSideCountEnum = .One
            break
        case .OneToMany:
            side1.countTablesRelationshipSideCountEnum = .One
            side2.countTablesRelationshipSideCountEnum = .Many
            break
        }
        
        return relationship
    }
    
    func saveRelationship(relationship: TablesRelationship) {
        DataManagerAPI.shared.addRelationship(dbFramework: dbFramework, relationship: relationship)
    }

}
