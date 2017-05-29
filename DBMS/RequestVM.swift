//
//  RequestViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    var dbFramework: DataBaseFramework = .None
    
    var requestName = ""
    
    let selectedItems = Variable<[RequestSelectionItem]>([RequestSelectionItem]())
    let availableSelectionItems = Variable<[RequestSelectionItem]>([RequestSelectionItem]())
    let source = Variable<RequestSourceTVCellModel>(RequestSourceTVCellModel())
    let conditionsItemsModels = Variable<[RequestConditionItemTVCellModel]>([RequestConditionItemTVCellModel]())
    let conditionsItems = Variable<[RequestConditionItem]>([RequestConditionItem]())
    
    let request = Variable<RequestRealmObject>(RequestRealmObject())
    
    init(dbFramework: DataBaseFramework, requestName: String) {
        super.init()
        self.requestName = requestName
        self.dbFramework = dbFramework
        self.relaunch()
        self.initBindings()
    }
    
    func relaunch() {
        self.createRequest()
    }
    
    func createRequest() {
        request.value =  DataManagerAPI.shared.request(dbFramework: dbFramework, name: requestName)
        print()
    }
    
    func initBindings() {
        _ = request.asObservable()
            .map({ (request) -> RequestSourceTVCellModel in
                let sourceModel = RequestSourceTVCellModel()
                if request.source?.tableName1 != nil {
                    sourceModel.sourceName += (request.source?.tableName1)!
                }
                if request.source?.tableName2 != nil {
                    if sourceModel.sourceName.characters.count > 0 {
                        sourceModel.sourceName += ", "
                    }
                    sourceModel.sourceName += (request.source?.tableName2)!
                }
                if request.source?.requestName1 != nil {
                    if sourceModel.sourceName.characters.count > 0 {
                        sourceModel.sourceName += ", "
                    }
                    sourceModel.sourceName += (request.source?.requestName1)!
                }
                if request.source?.requestName2 != nil {
                    if sourceModel.sourceName.characters.count > 0 {
                        sourceModel.sourceName += ", "
                    }
                    sourceModel.sourceName += (request.source?.requestName2)!
                }
                return sourceModel
            })
            .bindTo(self.source)
            .disposed(by: disposeBag)
        
        _ = request.asObservable()
            .map({ (request) -> [RequestSelectionItem] in
                var selectionItems = [RequestSelectionItem]()
                if request.source?.tableName1 != nil {
                    let tableData = DataManagerAPI.shared.getTable(dbFramework: self.dbFramework, name: (request.source?.tableName1)!)
                    if !TableData.isEmpty(tableData: tableData) {
                        for porperty in tableData.properties {
                            selectionItems.append(RequestSelectionItem(requestName: tableData.name, attributeName: porperty.name))
                        }
                    }
                }
                if request.source?.tableName2 != nil {
                    let tableData = DataManagerAPI.shared.getTable(dbFramework: self.dbFramework, name: (request.source?.tableName2)!)
                    if !TableData.isEmpty(tableData: tableData) {
                        for porperty in tableData.properties {
                            selectionItems.append(RequestSelectionItem(requestName: tableData.name, attributeName: porperty.name))
                        }
                    }
                }
                if request.source?.requestName1 != nil {
                    let subRequest = DataManagerAPI.shared.request(dbFramework: self.dbFramework, name: (request.source?.requestName1)!)
                    if !RequestRealmObject.isEmpty(request: subRequest) {
                        for attribute in subRequest.selectionAttributes {
                            selectionItems.append(RequestSelectionItem(requestName: subRequest.name, attributeName: attribute.attributeName))
                        }
                    }
                }
                if request.source?.requestName2 != nil {
                    let subRequest = DataManagerAPI.shared.request(dbFramework: self.dbFramework, name: (request.source?.requestName2)!)
                    if !RequestRealmObject.isEmpty(request: subRequest) {
                        for attribute in subRequest.selectionAttributes {
                            selectionItems.append(RequestSelectionItem(requestName: subRequest.name, attributeName: attribute.attributeName))
                        }
                    }
                }
                return selectionItems
            })
            .bindTo(self.availableSelectionItems)
            .disposed(by: disposeBag)
        
        
        _ = request.asObservable()
            .map({ (request) -> [RequestSelectionItem] in
                return Array(request.selectionAttributes)
            })
            .bindTo(self.selectedItems)
            .disposed(by: disposeBag)
        
        _ = request.asObservable()
            .map({ (request) -> [RequestConditionItem] in
                return Array(request.conditionItems)
            })
            .bindTo(self.conditionsItems)
            .disposed(by: disposeBag)
        
        _ = conditionsItems.asObservable()
            .map({ (items) -> [RequestConditionItemTVCellModel] in
                return items.map({ RequestConditionItemTVCellModel(requestConditionItem: $0) })
            })
            .bindTo(self.conditionsItemsModels)
            .disposed(by: disposeBag)
        
    }
    
    func selectionItemModel(forIndex index: Int) -> RequestSelectionItem {
        guard selectedItems.value.count > index else {
            return RequestSelectionItem()
        }
        return selectedItems.value[index]
    }
    
    func conditionItemModel(forIndex index: Int) -> RequestConditionItemTVCellModel {
        guard conditionsItemsModels.value.count > index else {
            return RequestConditionItemTVCellModel()
        }
        return conditionsItemsModels.value[index]
    }
    
    func pushSource(source: RequestSource) {
        request.value.source = source
        DataManagerAPI.shared.addRequest(dbFramework: dbFramework, request: request.value)
        self.relaunch()
    }
    
    func pushSelectedItems(items: [RequestSelectionItem]) {
        DataManagerAPI.shared.updateSelectedAttributes(request: request.value, attributes: items)
        self.relaunch()
    }
    
    func removeConditionItem(atIndex index: Int) {
        if conditionsItems.value.count <= index {
            return
        }
        let conditionItem = conditionsItems.value[index]
        DataManagerAPI.shared.removeConditionItem(request: request.value, conditionItem: conditionItem)
        request.value = request.value
    }
    
}
