//
//  DBFrameworkInteractorConnecter.swift
//
//
//  Created by Dmitrii Titov on 15.05.17.
//
//

import UIKit

class DBFrameworkInteractorConnecter: NSObject {
    
    fileprivate let sqliteImplementation = SQLiteFrameworkInteractor()
    fileprivate let fmbdImplementation = FMBDFrameworkInteractor()
    fileprivate let coreDataImplementation = CoreDataFrameworkInteractor()
    fileprivate let fileSystemImplementation = FileSystemFrameworkInteractor()
    
    let relationshipsManager: TablesReferencesManagerProtocol = TablesRelationshipsManagerRealm()
    
    let requestsManager: RequestsManagerProtocol = RequestsManagerRealm()
        
    func interactor(dbFramework: DataBaseFramework) -> FillingReadDMProtocol & FillingWriteDMProtocol & EditingTableCreateDropDMProtocol &  EditingTableEditingDMProtocol {
        switch dbFramework {
        case .SQLite:
            return sqliteImplementation
        case .FMDB:
            return fmbdImplementation
        case .CoreData:
            return coreDataImplementation
        case .FileSystem:
            return fileSystemImplementation
        default:
            print("tryed to use unsupported DB: \(dbFramework.rawValue)")
            return fmbdImplementation
        }
    }
    
    
    func reactOnAppBeingClosed() {
        relationshipsManager.clearRelationships(dbFramework: .CoreData)
        requestsManager.clearRequests(dbFramework: .CoreData)
    }
    
}
