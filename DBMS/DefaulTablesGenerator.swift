//
//  DefaulTablesGenerator.swift
//  DBMS
//
//  Created by Александр Кузяев 2 on 20/03/17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import SQLite

class DefaulTablesGenerator {
    
    init() { }
    
    static var db: Connection!
    static let id = Expression<Int64>("id")
    static let name = Expression<String>("name")
    
    static func setDefaultHumanSex(table: Table) {
        _ = try? db!.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name, unique: true)
            print("human_sex TABLE CREATED")
        })
    }
    
    static func setupRequiredTables() {
        let groupName = Expression<String>("group name")
        let tableName = Expression<String>("table name")
        let tablesAndGroupsTable = Table("Tables and groups")
        
        _ = try? db!.run(tablesAndGroupsTable.create { t in
            t.column(groupName)
            t.column(tableName)
            print("Tables and groups TABLE CREATED")
        })
    }
    
    static func setDefaultScramMaster(table: Table) {
        
        let superInt = Expression<Int64>("superInt")
        let superBool = Expression<Bool>("superBool")
        
        _ = try? db!.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(superInt)
            t.column(superBool)
            print("scram_master TABLE CREATED")
        })
    }
    
    static func setDefaultHuman(table: Table) {
        let age = Expression<Int64>("age")
        
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(age)
            print("human TABLE CREATED")
        })
    }
    
    static func setDefaultTask(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            print("task TABLE CREATED")
        })
    }
    
    static func setDefaultTaskState(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name, unique: true)
            print("task_state TABLE CREATED")
        })
    }
    
    static func setDefaultTaskPriority(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name, unique: true)
            print("task_priority TABLE CREATED")
        })
    }
    
    static func setDefaultTaskType(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name, unique: true)
            print("task_type TABLE CREATED")
        })
    }
    
    static func setDefaultDeadline(table: Table) {
        let date_start = Expression<String>("date_start")
        let date_end = Expression<String>("date_end")
        
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(date_start)
            t.column(date_end)
            print("deadline TABLE CREATED")
        })
    }
    
    static func setDefaultProductOwner(table: Table) {
        let project_description = Expression<String>("project_description")
        
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(project_description)
            print("product_owner TABLE CREATED")
        })
    }
    
    static func setDefaultProject(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            print("project TABLE CREATED")
        })
    }
    
    static func setDefaultTeam(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name)
            print("team TABLE CREATED")
        })
    }
    
    static func setDefaultClient(table: Table) {
        let project_description = Expression<String>("project_description")
        
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(project_description)
            print("client TABLE CREATED")
        })
    }
    
    static func setDefaultSprint(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            print("sprint TABLE CREATED")
        })
    }
    
    static func setDefaultScramMeeting(table: Table) {
        let goal = Expression<String>("goal")
        
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(goal)
            print("scram_meeting TABLE CREATED")
        })
    }
    
    static func setDefaultBuild(table: Table) {
        let version = Expression<String>("version")
        let changes = Expression<String>("changes")
        
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(version)
            t.column(changes)
            print("build TABLE CREATED")
        })
    }
    
    
    static func setDefaultTeamMember(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            print("team_member TABLE CREATED")
        })
    }
    
    static func setDefaultTeamMemberSpecialization(table: Table) {
        _ = try? db.run(table.create { t in
            t.column(id, primaryKey: true)
            t.column(name, unique: true)
            print("team_member_specialization TABLE CREATED")
        })
    }
}
