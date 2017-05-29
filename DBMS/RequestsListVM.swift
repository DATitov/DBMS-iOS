//
//  RequestsListViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestsListVM: NSObject {
    
    let disposeBag = DisposeBag()

    let requests = Variable<[RequestRealmObject]>([RequestRealmObject]())
    let cellsModels = Variable<[RequestTVCellModel]>([RequestTVCellModel]())
    
    var dbFramework: DataBaseFramework = .None
    
    init(dbFramework: DataBaseFramework) {
        super.init()
        self.dbFramework = dbFramework
        self.relaunch()
        self.initBindings()
    }
    
    func relaunch() {
        self.createRequests()
    }
    
    func createRequests() {
        requests.value = DataManagerAPI.shared.requests(dbFramework: dbFramework)
    }
    
    func initBindings() {
        requests.asObservable()
            .map({ $0.map({ RequestTVCellModel(request: $0) }) })
            .bindTo(self.cellsModels)
            .disposed(by: disposeBag)
    }
    
    func createNewRequest(name: String) -> RequestRealmObject? {
        if DataManagerAPI.shared.request(dbFramework: dbFramework, name: name).name == name {
            return nil
        }
        let request = RequestRealmObject()
        request.name = name        
        let source = RequestSource()
        request.source = source
        DataManagerAPI.shared.addRequest(dbFramework: dbFramework, request: request)
        return request
    }
    
    func removeRequest(atIndex index: Int) -> Bool {
        guard let request = { () -> RequestRealmObject? in
            if index >= requests.value.count {
                return nil
            }
            return requests.value[index]
            }() else {
            return false
        }
        DataManagerAPI.shared.removeRequest(request: request)
        self.relaunch()
        return true
    }
    
}
