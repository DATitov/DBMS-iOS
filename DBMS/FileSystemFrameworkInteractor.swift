//
//  FileSystemFrameworkInteractor.swift
//  DBMS
//
//  Created by Dmitrii Titov on 15.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import ObjectMapper

class FileSystemFrameworkInteractor: NSObject {
    
}

extension FileSystemFrameworkInteractor:  FillingReadDMProtocol {
    // MARK: Read
    
    func tablesCount() -> Int {
        return self.tablesNames().count
    }
    
    func tablesNames() -> [String] {
        return self.entitiesNames().map({ $0.replacingOccurrences(of: self.extentionString(), with: "") })
    }
    
    func table(name: String) -> TableData {
        guard let filePath = self.entityFilePath(name: name) else {
            return TableData(name: "Empty", properties: [])
        }
        guard FileManager.default.fileExists(atPath: filePath) else {
            return TableData(name: "Empty", properties: [])
        }
        return self.table(path: filePath)
    }
    
    func allTables() -> [TableData] {
        guard let pathEntities = DataBaseConnecter.shared.fileSystemEntitiesPathURL() else {
            return [TableData]()
        }
        var entitiesFiles = [String]()
        do {
            try entitiesFiles = FileManager.default.contentsOfDirectory(atPath: pathEntities)
        } catch  {
            return [TableData]()
        }
        
        var tables = [TableData]()
        for path in entitiesFiles.map({ pathEntities + "/" + $0 }) {
            tables.append(self.table(path: path))
        }
        
        return tables
    }
    
    func tableRecords(name: String) -> [Record] {
        guard let content = self.recordsFileContentObject(name: name) else {
            return [Record]()
        }
        return content.records
    }
    
}

extension FileSystemFrameworkInteractor: FillingWriteDMProtocol {
    // MARK: Write
    
    func addRecord(tableName: String, record: Record, error: inout Error?) {
        guard let fileHandle = self.recordsFileHandleForUpdation (name: tableName) else {
            error = DataManagerAPIError.NoObjectFounded
            return
        }
        let content = String(data: fileHandle.readDataToEndOfFile(), encoding: FileSystemHelper.shared.encoding)
        
        guard let length = content?.lengthOfBytes(using: FileSystemHelper.shared.encoding) else {
            error = DataManagerAPIError.Other
            fileHandle.closeFile()
            return
        }
        let tableData = DataManagerAPI.shared.getTable(dbFramework: .FileSystem, name: tableName)
        
        fileHandle.seek(toFileOffset: UInt64(length - 2))
        var recordString = record.toJSONString(tableData: tableData)//FileSystemHelper.shared.jsonRecord(tableData: tableData, record: record)
        if length != 15 {
            recordString = "," + recordString
        }
        recordString += "]}"
        fileHandle.write(recordString.data(using: FileSystemHelper.shared.encoding)!)
        
        fileHandle.closeFile()
    }
    
}

extension FileSystemFrameworkInteractor: EditingTableCreateDropDMProtocol {
    // MARK: Create & Drop
    
    func createTable(tableData: TableData, error: inout Error?) {
        guard let filePath = self.entityFilePath(name: tableData.name) else {
            error = DataManagerAPIError.NoObjectFounded
            return
        }
        if !FileManager.default.fileExists(atPath: filePath, isDirectory: nil) {
            guard let jsonContent = FileSystemEntity(tableData: tableData).toJSONString() else {
                error = DataManagerAPIError.Other
                return
            }
            if FileManager.default.createFile(atPath: filePath, contents: jsonContent.data(using: FileSystemHelper.shared.encoding), attributes: [:]) {
                print()
            }else{
                error = DataManagerAPIError.Other
                return
            }
            if !self.createRecordsFile(name: tableData.name) {
                self.dropTable(name: tableData.name, error: &error)
            }
        }else{
            error = DataManagerAPIError.Other
        }
    }
    
    func dropTable(name: String, error: inout Error?) {
        guard let filePath = self.entityFilePath(name: name) else {
            error = DataManagerAPIError.Other
            return
        }
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch let e {
                error = e
                return
            }
            self.dropRecordsFile(name: name)
        }else{
            print()
        }
    }
    
}

extension FileSystemFrameworkInteractor: EditingTableEditingDMProtocol {
    // MARK: Editing Schema
    
    func renameTable(oldTableName: String, newTableName: String, error: inout Error?) {
        guard let pathEntities = DataBaseConnecter.shared.fileSystemEntitiesPathURL() else {
            error = DataManagerAPIError.NoObjectFounded
            return
        }
        let filePath = pathEntities + "/\(oldTableName)" + self.extentionString()
        let newFilePath = pathEntities + "/\(newTableName)" + self.extentionString()
        guard FileManager.default.fileExists(atPath: filePath) && !FileManager.default.fileExists(atPath: newFilePath) else {
            error = DataManagerAPIError.NoObjectFounded
            return
        }
        let table = self.table(name: oldTableName)
        table.name = newTableName
        var error: Error?
        self.dropTable(name: oldTableName, error: &error)
        self.createTable(tableData: table, error: &error)
    }
    
    func addAttribute(tableName: String, attribute: TableProperty, error: inout Error?) {
        guard let fileHandle = self.entityFileHandleForUpdation(name: tableName) else {
            return
        }
        let table = DataManagerAPI.shared.getTable(dbFramework: .FileSystem, name: tableName)
        table.properties.append(attribute)
        fileHandle.truncateFile(atOffset: 0)
        let jsonString = FileSystemEntity(tableData: table).toJSONString()
        fileHandle.write((jsonString?.data(using: FileSystemHelper.shared.encoding))!)
        fileHandle.closeFile()
        
        self.clearRecordsFile(name: tableName)
    }
    
    func removeAttribute(tableName: String, attributeName: String, error: inout Error?) {
        guard let fileHandle = self.entityFileHandleForUpdation(name: tableName) else {
            error = DataManagerAPIError.NoObjectFounded
            return
        }
        let table = DataManagerAPI.shared.getTable(dbFramework: .FileSystem, name: tableName)
        table.properties = table.properties.filter({ $0.name.uppercased() != attributeName.uppercased() })
        fileHandle.truncateFile(atOffset: 0)
        let jsonString = FileSystemEntity(tableData: table).toJSONString()
        fileHandle.write((jsonString?.data(using: FileSystemHelper.shared.encoding))!)
        fileHandle.closeFile()
        
        self.clearRecordsFile(name: tableName)
    }
    
    func updateAttribute(tableName: String, oldAttributeName: String, attribute: TableProperty, error: inout Error?) {
        guard let fileHandle = self.entityFileHandleForUpdation(name: tableName) else {
            return
        }
        let table = DataManagerAPI.shared.getTable(dbFramework: .FileSystem, name: tableName)
        table.properties = table.properties.map({ (property) -> TableProperty in
            fileHandle.closeFile()
            return property.name.uppercased() == oldAttributeName.uppercased() ? attribute : property
        })
        fileHandle.truncateFile(atOffset: 0)
        let jsonString = FileSystemEntity(tableData: table).toJSONString()
        fileHandle.write((jsonString?.data(using: FileSystemHelper.shared.encoding))!)
        fileHandle.closeFile()
        
        self.clearRecordsFile(name: tableName)
    }
    
}

extension FileSystemFrameworkInteractor { // MARK: Helpers
    
    fileprivate func table(path: String) -> TableData {
        guard let content = self.entityFileContent(filePath: path) else {
            return TableData(name: "Empty", properties: [])
        }
        guard content.characters.count > 0 else {
            return TableData(name: "Empty", properties: [])
        }
        guard let entity = FileSystemEntity(JSONString: content) else {
            return TableData(name: "Empty", properties: [])
        }
        let table = TableData(fileSystemEntity: entity)
        return table
    }
    
    // MARK: Actions
    
    fileprivate func createRecordsFile(name: String) -> Bool {
        guard let filePath = self.recordsFilePath(name: name) else {
            return false
        }
        if !FileManager.default.fileExists(atPath: filePath, isDirectory: nil) {
            let jsonContent = self.emptyRecordsFileContent().data(using: FileSystemHelper.shared.encoding)
            if FileManager.default.createFile(atPath: filePath, contents: jsonContent, attributes: [:]) {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    fileprivate func dropRecordsFile(name: String) {
        guard let filePath = self.recordsFilePath(name: name) else {
            return
        }
        if FileManager.default.fileExists(atPath: filePath) {
            do {
                try FileManager.default.removeItem(atPath: filePath)
            } catch  {
                print()
            }
        }else{
            print()
        }
    }
    
    fileprivate func clearRecordsFile(name: String) {
        guard let filePath = self.recordsFilePath(name: name) else {
            return
        }
        do {
            try self.emptyRecordsFileContent().write(toFile: filePath, atomically: true, encoding: FileSystemHelper.shared.encoding)
        } catch {
            print(error)
        }
    }
    
    // MARK: File Path
    
    fileprivate func entityFilePath(name: String) -> String? {
        guard let pathEntyties = DataBaseConnecter.shared.fileSystemEntitiesPathURL() else {
            return nil
        }
        return pathEntyties + "/\(name)" + self.extentionString()
    }
    
    fileprivate func recordsFilePath(name: String) -> String? {
        guard let pathRecords = DataBaseConnecter.shared.fileSystemRecordsPathURL() else {
            return nil
        }
        return pathRecords + "/\(name)" + self.extentionString()
    }
    
    // MARK: File Handle
    
    fileprivate func entityFileHandleForRead(name: String) -> FileHandle? {
        guard let filePath = self.entityFilePath(name: name) else {
            return nil
        }
        return self.fileHandleForRead(filePath: filePath)
    }
    
    fileprivate func entityFileHandleForUpdation(name: String) -> FileHandle? {
        guard let filePath = self.entityFilePath(name: name) else {
            return nil
        }
        return self.fileHandleForUpdation(filePath: filePath)
    }
    
    fileprivate func recordsFileHandleForRead (name: String) -> FileHandle? {
        guard let filePath = self.recordsFilePath(name: name) else {
            return nil
        }
        return self.fileHandleForRead(filePath: filePath)
    }
    
    fileprivate func recordsFileHandleForUpdation (name: String) -> FileHandle? {
        guard let filePath = self.recordsFilePath(name: name) else {
            return nil
        }
        return self.fileHandleForUpdation(filePath: filePath)
    }
    
    fileprivate func fileHandleForRead(filePath: String) -> FileHandle? {
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        guard let fileHandle = FileHandle(forReadingAtPath: filePath) else {
            return nil
        }
        return fileHandle
    }
    
    fileprivate func fileHandleForUpdation(filePath: String) -> FileHandle? {
        guard FileManager.default.fileExists(atPath: filePath) else {
            return nil
        }
        guard let fileHandle = FileHandle(forUpdatingAtPath: filePath) else {
            return nil
        }
        return fileHandle
    }
    
    fileprivate func entitiesNames() -> [String] {
        guard let pathEntities = DataBaseConnecter.shared.fileSystemEntitiesPathURL() else {
            return [String]()
        }
        guard let content = try? FileManager.default.contentsOfDirectory(atPath: pathEntities) else {
            return [String]()
        }
        return content
    }
    
    // MARK: Content
    
    fileprivate func entityFileContent(name: String) -> String? {
        guard let filePath = self.entityFilePath(name: name) else {
            return nil
        }
        return self.entityFileContent(filePath: filePath)
    }
    
    fileprivate func entityFileContent(filePath: String) -> String? {
        guard let fileHandle = self.fileHandleForRead(filePath: filePath) else {
            return nil
        }
        guard let contentSting = String(data: fileHandle.readDataToEndOfFile(), encoding: FileSystemHelper.shared.encoding) else {
            fileHandle.closeFile()
            return nil
        }
        return contentSting
    }
    
    fileprivate func recordsFileContent(name: String) -> String? {
        guard let fileHandle = self.recordsFileHandleForRead (name: name) else {
            return nil
        }
        guard let contentSting = String(data: fileHandle.readDataToEndOfFile(), encoding: FileSystemHelper.shared.encoding) else {
            fileHandle.closeFile()
            return nil
        }
        return contentSting
    }
    
    fileprivate func recordsFileContentObject(name: String) -> FileSystemRecordsFileContent? {
        guard let content = self.recordsFileContent(name: name) else {
            return nil
        }
        guard let contentObject = FileSystemRecordsFileContent(JSONString: content) else {
            return nil
        }
        return contentObject
    }
    
    // MARK: Strings
    
    fileprivate func extentionString() -> String {
        return ".txt"
    }
    
    fileprivate func emptyRecordsFileContent() -> String {
        return "{\"records\": []}"
    }
    
}
