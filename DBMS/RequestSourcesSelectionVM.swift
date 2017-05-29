//
//  RequestSourcesSelectionViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestSourcesSelectionVM: NSObject {
    
    var dbFramework: DataBaseFramework = .None
    
    var requestSource: RequestSource!
    
    let sourceVariantsTablesRequests = Variable<[RequestRealmObject]>([RequestRealmObject]())
    let sourceVariantsRequests = Variable<[RequestRealmObject]>([RequestRealmObject]())
    var requestsNamesToSkip = [String]()
    
    var selectionAction: ((RequestSource) -> ())!
    
    init(dbFramework: DataBaseFramework, requestSource: RequestSource, requestsNamesToSkip: [String], selectionAction: @escaping ((RequestSource) -> ())) {
        super.init()
        self.dbFramework = dbFramework
        self.requestSource = requestSource
        self.selectionAction = selectionAction
        self.requestsNamesToSkip = requestsNamesToSkip
        self.relaunch()
    }
    
    func relaunch() {
        self.createSourceVariants()
    }
    
    func createSourceVariants() {
        sourceVariantsTablesRequests.value = {
            let tables = DataManagerAPI.shared.getAllTables(dbFramework: dbFramework)
            return tables
                .filter({ (tableData) -> Bool in
                    for name in self.requestsNamesToSkip {
                        if name == tableData.name {
                            return false
                        }
                    }
                    return true
                })
                .map({ RequestRealmObject(tableData: $0) })
        }()
        sourceVariantsRequests.value = {
            let requests = DataManagerAPI.shared.requests(dbFramework: dbFramework)
                .filter({ (request) -> Bool in
                    for name in self.requestsNamesToSkip {
                        if name == request.name {
                            return false
                        }
                    }
                    return true
            })
            return requests
        }()
        
    }
    
    func indexPathsOfSelectedItems() -> [IndexPath] {
        let index: ((_ name: String, _ requests: [RequestRealmObject]) -> Int) = { (name, requests) -> Int in
            for (index, request) in requests.enumerated() {
                if request.name.uppercased() == name.uppercased() {
                    return index
                }
            }
            return 0
        }
        var indexPaths = [IndexPath]()
        if requestSource.tableName1 != nil {
            let index = index(requestSource.tableName1!, sourceVariantsTablesRequests.value)
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        if requestSource.tableName2 != nil {
            let index = index(requestSource.tableName2!, sourceVariantsTablesRequests.value)
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        if requestSource.requestName1 != nil {
            let index = index(requestSource.requestName1!, sourceVariantsRequests.value)
            indexPaths.append(IndexPath(row: index, section: 1))
        }
        if requestSource.requestName2 != nil {
            let index = index(requestSource.requestName2!, sourceVariantsRequests.value)
            indexPaths.append(IndexPath(row: index, section: 1))
        }
        return indexPaths
    }
    
    // MARK: Data Source
    
    func tableRequestName(forIndex index: Int) -> String {
        guard let request = self.tableRequest(forIndex: index) else {
            return ""
        }
        return request.name
    }
    
    func requestName(forIndex index: Int) -> String {
        guard let request = self.request(forIndex: index) else {
            return ""
        }
        return request.name
    }
    
    func tableRequest(forIndex index: Int) -> RequestRealmObject? {
        if sourceVariantsTablesRequests.value.count <= index {
            return nil
        }
        return sourceVariantsTablesRequests.value[index]
    }
    
    func request(forIndex index: Int) -> RequestRealmObject? {
        if sourceVariantsRequests.value.count <= index {
            return nil
        }
        return sourceVariantsRequests.value[index]
    }
    
    // MARK: Actions
    
    func selectSources(source1Path: IndexPath, source2Path: IndexPath?) {
        let newSource = RequestSource()
        if source1Path.section == 0 {
            newSource.tableName1 = self.tableRequestName(forIndex: source1Path.row)
        }else{
            newSource.requestName1 = self.requestName(forIndex: source1Path.row)
        }
        if source2Path != nil {
            if source1Path.section == 0 {
                newSource.tableName2 = self.tableRequestName(forIndex: source2Path!.row)
            }else{
                newSource.requestName2 = self.requestName(forIndex: source2Path!.row)
            }
        }
        selectionAction(newSource)
    }
    
}
