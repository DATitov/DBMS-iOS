//
//  RequestExecutionResultViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 24.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestExecutionResultVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    let request = Variable<RequestRealmObject>(RequestRealmObject())
    let records = Variable<[Record]>([Record]())
    let cellsModels = Variable<[RecordPresentationModel]>([RecordPresentationModel]())
    var table = TableData(name: "Empty", properties: [])
    var dbFramework: DataBaseFramework = .None
    var requestName = ""
    
    init(dbFramework: DataBaseFramework, requestName: String) {
        super.init()
        self.dbFramework = dbFramework
        self.requestName = requestName
        self.initBindings()
    }
    
    func relaunch() {
        request.value = DataManagerAPI.shared.request(dbFramework: dbFramework, name: requestName)
        table = DataManagerAPI.shared.requestExecutionManager.tableData(dbFramework: dbFramework, requestName: requestName)
        records.value = DataManagerAPI.shared.requestExecutionManager.records(dbFramework: dbFramework, requestName: requestName)
        print()
    }
    
    func cellModel(forIndex index: Int) -> RecordPresentationModel {
        if index >= cellsModels.value.count {
            return RecordPresentationModel()
        }
        return cellsModels.value[index]
    }
    
    func initBindings() {
        _ = records.asObservable()
            .map({ $0.map({ RecordPresentationModel(tableData: self.table, record: $0) }) })
            .bindTo(self.cellsModels)
            .disposed(by: disposeBag)
    }
    
}
