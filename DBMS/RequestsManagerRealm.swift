//
//  RequestsManagerRealm.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RealmSwift

class RequestsManagerRealm: NSObject {
    
    let realm = try! Realm()
    
    override init() {
        super.init()
        self.setupBase()
    }
    
    func setupBase() {
        let storages = realm.objects(RequestsStorage.self)
        let dbFrameworks = DataBasesManager.shared.dataBasesTypesAvailable()
        if !(storages.count == dbFrameworks.count) {
            do {
                try realm.write {
                    realm.delete(storages)
                    realm.add(dbFrameworks.map({ RequestsStorage(dbFramework: $0) }))
                }
            } catch  {
                print(error)
            }
        }
    }
    
}

extension RequestsManagerRealm: RequestsManagerProtocol {
    
    func request(dbFramework: DataBaseFramework, name: String) -> RequestRealmObject {
        let requests = self.requests(dbFramework: dbFramework).filter { (request) -> Bool in
            return request.name == name
        }
        if requests.count > 0 {
            return requests[0]
        }else{
            return RequestRealmObject()
        }
    }
    
    func requests(dbFramework: DataBaseFramework) -> [RequestRealmObject] {
        guard let storage = self.storage(dbFramework: dbFramework) else {
            return [RequestRealmObject]()
        }
        let requests = Array(storage.requests)
        return requests
    }
    
    func addRequest(dbFramework: DataBaseFramework, request: RequestRealmObject) {
        guard let storage = self.storage(dbFramework: dbFramework) else {
            return 
        }
        do {
            try realm.write {
                storage.requests.append(request)
            }
        } catch  {
            print(error)
        }
    }
    
    func removeRequest(request: RequestRealmObject) {
        do {
            try realm.write {
                realm.delete(request)
            }
        } catch  {
            print(error)
        }
    }
    
    func clearRequests(dbFramework: DataBaseFramework) {
        guard let storage = self.storage(dbFramework: dbFramework) else {
            return
        }
        do {
            try realm.write {
                storage.requests.removeAll()
            }
        } catch  {
            print(error)
        }
    }
    
    func updateSource(dbFramework: DataBaseFramework, request: RequestRealmObject, source: RequestSource) {
        do {
            try realm.write {
                request.selectionAttributes.removeAll()
                request.source = source
            }
        } catch  {
            print(error)
        }
    }
    
    func updateSelectedAttributes(request: RequestRealmObject, attributes: [RequestSelectionItem]) {
        let selectedAttributes = { () -> List<RequestSelectionItem> in 
            let selectedAttributes = List<RequestSelectionItem>()
            for attribute in attributes {
                selectedAttributes.append(attribute)
            }
            return selectedAttributes
        }()
        do {
            try realm.write {
                request.selectionAttributes.removeAll()
                request.conditionItems.removeAll()
                request.selectionAttributes.append(contentsOf: selectedAttributes)
            }
        } catch  {
            print(error)
        }
    }
    
    func addCondition(request: RequestRealmObject, conditionItem: RequestConditionItem) {
        do {
            try realm.write {
                request.conditionItems.append(conditionItem)
            }
        } catch  {
            print(error)
        }
        print()
    }
    
    func conditionUpdateSelectionItem(conditionItem: RequestConditionItem, selectedItem: RequestSelectionItem) {
        do {
            try realm.write {
                conditionItem.selectedItem = selectedItem
            }
        } catch  {
            print(error)
        }
    }
    
    func conditionUpdateType(conditionItem: RequestConditionItem, typeString: String) {
        do {
            try realm.write {
                conditionItem.type = typeString
            }
        } catch  {
            print(error)
        }
    }
    
    func conditionUpdateValue(conditionItem: RequestConditionItem, valueString: String) {
        do {
            try realm.write {
                conditionItem.value = valueString
            }
        } catch  {
            print(error)
        }
    }
    
    func removeConditionItem(request: RequestRealmObject, conditionItem: RequestConditionItem) {
        do {
            try realm.write {
                let index = request.conditionItems.index(of: conditionItem)
                request.conditionItems.remove(objectAtIndex: index!)
                realm.delete(conditionItem)
            }
        } catch  {
            print(error)
        }
    }
    
}

extension RequestsManagerRealm { // MARK: Helpers
    
    fileprivate func storage(dbFramework: DataBaseFramework) -> RequestsStorage? {
        let storages = realm.objects(RequestsStorage.self)
        for storage in storages {
            if storage.dbFrameworkEnum == dbFramework {
                return storage
            }
        }
        return nil
    }
    
}
