//
//  EditColumnViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class EditColumnVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    var isNewColumn: Bool = false
    
    let editingState = Variable<Bool>(false)
    let column = Variable<TableProperty>(TableProperty(name: "", type: .None))
    let name = Variable<String>("")
    let dataType = Variable<DataType>(.None)
    let isUnique = Variable<Bool>(false)
    let isPrimary = Variable<Bool>(false)
    let isNullable = Variable<Bool>(false)
    
    var dbFramework: DataBaseFramework = .None
    var table : TableData!
    
    init(dbFramework: DataBaseFramework, tableName: String, columnName: String) {
        super.init()
        self.dbFramework = dbFramework
        self.relaunch(tableName: tableName, columnName: columnName)
        self.initBindings()
    }
    
    func relaunch(tableName: String, columnName: String) {
        table = DataManagerAPI.shared.getTable(dbFramework: dbFramework, name: tableName)
        column.value = table.getProperty(name: columnName) ?? TableProperty(name: "", type: .None)
    }
    
    func initBindings() {//name, isUnique, isPrimary, isNullable
        
        _ = Observable.combineLatest(dataType.asObservable(), isUnique.asObservable(), isPrimary.asObservable(), isNullable.asObservable(),
                                     resultSelector: { (dataType, isUnique, isPrimary, isNullable) -> TableProperty in
                                        let column = TableProperty(name: self.column.value.name, type: dataType)
                                        column.unique = isUnique
                                        column.primaryKey = isPrimary
                                        column.nullable = isNullable
                                        return column
        })
            .skip(4)
            .subscribe(onNext: { (column) in
                var error: Error?
                DataManagerAPI.shared.updateAttribute(dbFramework: self.dbFramework, tableName: self.table.name, oldAttributeName: column.name, attribute: column, error: &error)
                if error == nil {
                    self.relaunch(tableName: self.table.name, columnName: self.column.value.name)
                }else{
                    print(error)
                }
            })
            .disposed(by: disposeBag)
        
        
    }
    
    
    func columnNameAvailable(name: String) -> Bool {
        let uppercasedName = name.uppercased()
        var names = [String]()
        for attribute in table.properties {
            names.append(attribute.name)
        }
        for nm in names {
            let uppercasedNM = nm.uppercased()
            if uppercasedName == uppercasedNM {
                return false
            }
        }
        return true
    }
    
    func updateColumn(newName: String, column: TableProperty) -> Observable<Void> {
        let newAttribute = TableProperty(name: newName, type: column.type)
        newAttribute.foreighKey = column.foreighKey
        newAttribute.primaryKey = column.primaryKey
        newAttribute.unique = column.unique
        newAttribute.nullable = column.nullable
        var error: Error?
        DataManagerAPI.shared.updateAttribute(dbFramework: dbFramework, tableName: table.name, oldAttributeName: column.name, attribute: newAttribute, error: &error)
        return Observable.create({ (observer) -> Disposable in
            if error != nil {
                observer.onError(error!)
            }else {
                observer.onCompleted()
            }
            
            return Disposables.create()
        })
    }
    
    func removeColumn() -> Observable<Void> {
        var error: Error?
        if table.properties.count == 1 {
            DataManagerAPI.shared.dropTable(dbFramework: dbFramework, name: table.name, error: &error)
            return Observable.create({ (observer) -> Disposable in
                if error != nil {
                    observer.onError(error!)
                }else {
                    observer.onCompleted()
                }
                
                return Disposables.create()
            })
        }else {
            DataManagerAPI.shared.removeColumn(dbFramework: dbFramework, tableName: table.name, columnName: column.value.name, error: &error)
            return Observable.create({ (observer) -> Disposable in
                if error != nil {
                    observer.onError(error!)
                }else {
                    observer.onCompleted()
                }
                
                return Disposables.create()
            })
        }
    }
    
    
}
