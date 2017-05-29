//
//  EditRelationshipViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class EditRelationshipVM: NSObject {
    
    let disposeBag = DisposeBag()

    var relationship: TablesRelationship
    
    var tables = [TableData]()
    
    let table1 = Variable<TableData>(TableData())
    let table2 = Variable<TableData>(TableData())
    let dataType = Variable<DataType>(DataType.None)
    
    var dbFramework = DataBaseFramework.None
    
    init(dbFramework: DataBaseFramework, relationship: TablesRelationship?) {
        self.relationship = relationship ?? TablesRelationship()
        self.dbFramework = dbFramework
        super.init()
        self.createTables()
        self.initBindings()
    }
    
    func createTables() {
        tables = DataManagerAPI.shared.getAllTables(dbFramework: dbFramework)
    }
    
    func initBindings() {
        
    }
    
}
