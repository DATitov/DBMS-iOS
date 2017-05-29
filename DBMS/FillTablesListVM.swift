
//
//  viewModel.swift
//  DBMS
//
//  Created by Александр Кузяев 2 on 21/03/17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import SimplePDF

class FillTablesListVM: NSObject {
    
    private var cellsModels = [TablesListEditingCellModel]()
    
    private(set) var dbFramework : DataBaseFramework = .None
    
    init(dbFramework: DataBaseFramework) {
        super.init()
        self.dbFramework = dbFramework
    }
    
    func relaunch() {
        self.createCellsModels()
    }
    
    private func createCellsModels() {
        let tables = DataManagerAPI.shared.getAllTables(dbFramework: dbFramework)
        var cellsModels = [TablesListEditingCellModel]()
        for table in tables {
            cellsModels.append(TablesListEditingCellModel(titleText: table.name, isEditing: false, selected: false))
        }
        self.cellsModels = cellsModels
    }
    
    func numberOfTables() -> Int {
        return self.cellsModels.count
    }
    
    func cellModel(index: Int) -> TablesListEditingCellModel {
        let count = self.numberOfTables()
        if count <= index {
            return TablesListEditingCellModel(titleText: "", isEditing: false, selected: false)
        }
        return cellsModels[index]
    }
}
