//
//  TablesReferencesManager.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RealmSwift

class TablesRelationshipsManagerRealm: NSObject {
    
    let realm = try! Realm()
    
    override init() {
        super.init()
        self.setupBase()
    }
    
    func setupBase() {
        let storages = realm.objects(TablesRelationshipStorage.self)
        let dbFrameworks = DataBasesManager.shared.dataBasesTypesAvailable()
        if !(storages.count == dbFrameworks.count) {
            do {
                try realm.write {
                        realm.delete(storages)
                        realm.add(dbFrameworks.map({ TablesRelationshipStorage(dbFramework: $0) }))
                }
            } catch  {
                print(error)
            }
        }
    }
    
}

extension TablesRelationshipsManagerRealm: TablesReferencesManagerProtocol {
    
    func relationships(dbFramework: DataBaseFramework) -> [TablesRelationship] {
        guard let storage = self.storage(dbFramework: dbFramework) else {
            return [TablesRelationship]()
        }
        let relationships = Array(storage.relationships)
        return relationships
    }
    
    func addRelationship(dbFramework: DataBaseFramework, relationship: TablesRelationship) {
        guard let storage = self.storage(dbFramework: dbFramework) else {
            return
        }
        do {
            try realm.write {
                    storage.relationships.append(relationship)
            }
        } catch  {
            print(error)
        }
    }
    
    func removeRelationship(dbFramework: DataBaseFramework, relationship: TablesRelationship) {
        do {
            try realm.write {
                    realm.delete(relationship)
            }
        } catch  {
            print(error)
        }
    }
    
    func clearRelationships(dbFramework: DataBaseFramework) {
        let relationships = self.relationships(dbFramework: dbFramework)
        do {
            try realm.write {
                for relationship in relationships {
                    realm.delete(relationship)
                }
            }
        } catch  {
            print(error)
        }
    }
    
}

extension TablesRelationshipsManagerRealm { // MARK: Helpers
    
    fileprivate func storage(dbFramework: DataBaseFramework) -> TablesRelationshipStorage? {
        let storages = realm.objects(TablesRelationshipStorage.self)
        for storage in storages {
            if storage.dbFrameworkEnum == dbFramework {
                return storage
            }
        }
        return nil
    }
    
}
