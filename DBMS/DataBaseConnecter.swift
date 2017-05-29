//
//  DataBaseConnecter.swift
//  DBMS
//
//  Created by Dmitrii Titov on 06.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import SQLite
import FMDB
import CoreData
import RxSwift

private let sharedInstance = DataBaseConnecter()

class DataBaseConnecter: NSObject {
    
    let persistentContainer = Variable<NSPersistentContainer>(DataBaseConnecter.coreData())
    
    class var shared : DataBaseConnecter {
        return sharedInstance
    }

    func dataBase(dbFramework: DataBaseFramework) -> Any? {
        switch dbFramework {
        case .SQLite:
            return self.sqliteDB()
        case .FMDB:
            return self.fmdbDB()
        case .CoreData:
            return self.persistentContainer.value
        default:
            print("DataBaseConnecter dataBase() unsupported DB Type: \(dbFramework.rawValue)")
            return nil
        }
    }
    
    func fmdbQueue() -> FMDatabaseQueue {
        let fmdbQueue = FMDatabaseQueue(path: self.pathToDB(dbFramework: .FMDB))
        if fmdbQueue == nil {
            print("Can not create FMDatabaseQueue")
        }
        return fmdbQueue!
    }
    
    func updatePersistentContainer(model: NSManagedObjectModel) {
        self.persistentContainer.value = DataBaseConnecter.coreData(model: model)
    }
    
    func fileSystemEntitiesPathURL() -> String? {
        guard let dbPath = self.fileFystemDataBaseDirectoryURL()  else {
            return nil
        }
        let path = dbPath + "/Entities"
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: [:])
            } catch {
                return nil
            }
        }
        return path
    }
    
    func fileSystemRecordsPathURL() -> String? {
        guard let dbPath = self.fileFystemDataBaseDirectoryURL()  else {
            return nil
        }
        let path = dbPath + "/Records"
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: false, attributes: [:])
            } catch {
                return nil
            }
        }
        return path
    }
    
}

extension DataBaseConnecter { // MARK: Supporting
    
    fileprivate func fileFystemDataBaseDirectoryURL() -> String? {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbDirectoryPath = documentsDirectory + "/FileSystemDataBase"
        if !FileManager.default.fileExists(atPath: dbDirectoryPath) {
            do {
                try FileManager.default.createDirectory(atPath: dbDirectoryPath, withIntermediateDirectories: false, attributes: [:])
            } catch {
                return nil
            }
        }
        return dbDirectoryPath
    }
    
    fileprivate func sqliteDB() -> Connection? {
        let path = self.pathToDB(dbFramework: .SQLite)
        let db = try? Connection(path)
        return db
    }
    
    fileprivate func fmdbDB() -> FMDatabase? {
        var db: FMDatabase?
        let path = self.pathToDB(dbFramework: .FMDB)
        //if !FileManager.default.fileExists(atPath: path) {
            db = FMDatabase(path: path)
        //}
        if db == nil {
            print("Can not connect to the FMDB Data Base")
            return db
        }
        return db
    }
    
    fileprivate static func coreData(model: NSManagedObjectModel) -> NSPersistentContainer {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
            let pc = NSPersistentContainer(name: "CoreDataDB", managedObjectModel: model)
            pc.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        return pc
    }
    
    fileprivate static func coreData() -> NSPersistentContainer {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let pc = NSPersistentContainer(name: "CoreDataDB")
        pc.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return pc
    }
    
    fileprivate func pathToDB(dbFramework: DataBaseFramework) -> String {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        switch dbFramework {
        case .SQLite:
            return "\(path)/db.sqlite3"
        case .FMDB:
            return "\(path)/db_fmdb"
        default:
            print("DataBaseConnecter pathToDB() unsupported DB Type: \(dbFramework.rawValue)")
            return ""
        }
    }
}

