//
//  EditTablesListViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class EditTablesListVM: NSObject {
    
    private var tablesCellsModels = [TablesListEditingCellModel]()
    private var relationshipsCellsModels = [RelationshipTVCellModel]()
    private var relationships = [TablesRelationship]()
    
    private(set) var dbFramework : DataBaseFramework = .None
    
    init(dbFramework: DataBaseFramework) {
        super.init()
        self.dbFramework = dbFramework
    }
    
    func relaunch() {
        self.createCellsModels()
        self.createRelationshipCellsModels()
    }
    
    private func createCellsModels() {
        let tables = DataManagerAPI.shared.getAllTables(dbFramework: dbFramework)
            .sorted(by: { $0.name < $1.name })
        var tablesCellsModels = [TablesListEditingCellModel]()
        for table in tables {
            tablesCellsModels.append(TablesListEditingCellModel(titleText: table.name, isEditing: false, selected: false))
        }
        self.tablesCellsModels = tablesCellsModels
    }
    
    private func createRelationshipCellsModels() {
        relationships = DataManagerAPI.shared.references(dbFramework: dbFramework)
        relationshipsCellsModels = relationships.map({ RelationshipTVCellModel(relationship: $0) })
    }
    
    func numberOfTables() -> Int {
        return self.tablesCellsModels.count
    }
    
    func numberOfReferences() -> Int {
        return self.relationshipsCellsModels.count
    }
    
    func tableCellModel(index: Int) -> TablesListEditingCellModel {
        let count = self.numberOfTables()
        if count <= index {
            return TablesListEditingCellModel(titleText: "", isEditing: false, selected: false)
        }
        return tablesCellsModels[index]
    }
    
    func relationshipCellModel(index: Int) -> RelationshipTVCellModel {
        let count = self.numberOfReferences()
        if count <= index {
            return RelationshipTVCellModel()
        }
        return relationshipsCellsModels[index]
    }
    
    func switchSelection(index: Int) {
        let cellModel = self.tableCellModel(index: index)
        self.updateSelection(index: index, selected: !cellModel.selected)
    }
    
    func updateSelection(index: Int, selected: Bool) {
        let count = self.numberOfTables()
        if count <= index {
            return
        }
        let cellModel = self.tableCellModel(index: index)
        cellModel.selected = selected
    }
    
    func updateEditing(editing: Bool) {
        for model in tablesCellsModels {
            model.isEditing = editing
        }
    }
    
    func removeTable(atIndex index: Int) {
        guard let name = { () -> String? in
            if self.tablesCellsModels.count <= index {
                return nil
            }else{
                return self.tablesCellsModels[index].titleText
            }
            }() else {
                return
        }
        self.removeTables(names: [name])
    }
    
    func removeRelationship(atIndex index: Int) {
        if relationships.count <= index {
            return
        }
        DataManagerAPI.shared.removeRelationship(dbFramework: dbFramework, relationship: relationships[index])
    }
    
    func removeSelectedTables() {
        var names = [String]()
        for model in self.tablesCellsModels {
            if model.selected {
                names.append(model.titleText)
            }
        }
        self.removeTables(names: names)
    }
    
    func removeTables(names: [String]) {
        for name in names {
            var error : Error?
            DataManagerAPI.shared.dropTable(dbFramework: dbFramework, name: name, error: &error)
            if error != nil {
                print(error ?? "")
            }
        }
    }
    
}
