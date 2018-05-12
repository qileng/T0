//
//  TaskDAO.swift
//  HALP
//
//  Created by FlikHu on 5/10/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import SQLite3

// Database access methods for task class, including all CRUD operations
// PLEASE ENCODE ALL DATA IN UTF-8 OR YOU WILL GET GARBLED DATABASE ENTRIES!!!
final class TaskDAO: Task {
    
    //Create a new task in local database, associated with a user
    //Return true for success, false otherwise
    func saveTaskInfoToLocalDB(userId: Int64) -> Bool {
        //Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            return false
        }
        
        //SQL command to insert into TaskData table
        let insertQueryString = "INSERT INTO TaskData " +
        "(task_id, task_title, task_desc, category, alarm, deadline, soft_deadline, schedule, duration, task_priority, schedule_start, user_id, last_update) " +
        "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

        let taskId = self.getTaskId()
        let title = self.getTitle() as NSString
        let taskDesc = self.getDescription() as NSString
        let category = self.getCategory().rawValue
        let alarm = self.getAlarm()
        let deadline = self.getDeadline()
        let softDeadline = self.getSoftDeadline()
        let schedule = self.getSchedule()
        let duration = self.getDuration()
        let priority = self.getPriority()
        let scheduleStart = self.getScheduleStart()
        let last_update = Date().timeIntervalSince1970
        
        //statement for entry binding
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, insertQueryString, -1, &stmt, nil)
        sqlite3_bind_int64(stmt, 1, taskId)
        sqlite3_bind_text(stmt, 2, title.utf8String, -1, nil)
        sqlite3_bind_text(stmt, 3, taskDesc.utf8String, -1, nil)
        sqlite3_bind_double(stmt, 4, category)
        sqlite3_bind_int(stmt, 5, Int32(alarm))
        sqlite3_bind_int(stmt, 6, Int32(deadline))
        sqlite3_bind_int(stmt, 7, Int32(softDeadline))
        sqlite3_bind_int(stmt, 8, Int32(schedule))
        sqlite3_bind_int(stmt, 9, Int32(duration))
        sqlite3_bind_double(stmt, 10, priority)
        sqlite3_bind_int(stmt, 11, Int32(scheduleStart))
        sqlite3_bind_int64(stmt, 12, userId)
        sqlite3_bind_int(stmt, 13, Int32(last_update))
        
        //Close database connection to prevent database from locking
        if sqlite3_step(stmt) == SQLITE_DONE {
            sqlite3_close(dbpointer)
            return true
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbpointer)!)
            print(errmsg)
            print(sqlite3_close(dbpointer))
            return false
        }
    }
    
    //Read a single task
    func fetchTaskInfoFromLocalDB(taskId: Int64) throws -> [Any] {
        //Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            throw RuntimeError.DBError("Local DB does not exist!")
        }
        
        //SQL command for fecting a row from database base on taskId
        let selectQueryString = "SELECT * FROM TaskData WHERE task_id=" + String(taskId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [Any]()
        
        //Traverse through the specific row
        while sqlite3_step(stmt) == SQLITE_ROW {
            let taskId = sqlite3_column_int64(stmt, 0)
            let title = String(cString: sqlite3_column_text(stmt, 1))
            let description = String(cString: sqlite3_column_text(stmt, 2))
            let category = sqlite3_column_double(stmt, 3)
            let alarm = sqlite3_column_int(stmt, 4)
            let deadline = sqlite3_column_int(stmt, 5)
            let softDeadline = sqlite3_column_int(stmt, 6)
            let schedule = sqlite3_column_int(stmt, 7)
            let during = sqlite3_column_int(stmt, 8)
            let priority = sqlite3_column_double(stmt, 9)
            let scheduleStart = sqlite3_column_int(stmt, 10)
            let user_id = sqlite3_column_int64(stmt, 11)
            let last_update = sqlite3_column_int(stmt, 12)
            queryResult.append(taskId)
            queryResult.append(title)
            queryResult.append(description)
            queryResult.append(category)
            queryResult.append(alarm)
            queryResult.append(deadline)
            queryResult.append(softDeadline)
            queryResult.append(schedule)
            queryResult.append(during)
            queryResult.append(priority)
            queryResult.append(scheduleStart)
            queryResult.append(user_id)
            queryResult.append(last_update)
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return queryResult
    }
    
    //Read a list of taskId associated with a user
    func fetchTaskIdListFromLocalDB(userId: Int64) throws -> [Int64] {
        //Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            throw RuntimeError.DBError("Local DB does not exist!")
        }
        
        //SQL command for fecting a row from database base on taskId
        let selectQueryString = "SELECT task_id FROM TaskData WHERE user_id=" + String(userId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [Int64]()
        
        //Traverse through the specific row
        while sqlite3_step(stmt) == SQLITE_ROW {
            let taskId = sqlite3_column_int64(stmt, 0)
            queryResult.append(taskId)
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return queryResult
    }
    
    // Update function
    // One size fits all update method with optional arguments
    // userId and taskId should never be updated
    // "`" is treated as a special character, task form should valid that user input contains no " ` "
    // Return true for success false otherwise
    func updateTaskInfoInLocalDB(taskId: Int64, taskTitle: String? = nil, taskDesc: String? = nil, category: Double? = nil,
                                 alarm: Int? = nil, deadline: Int? = nil, softDeadline: Int? = nil, schedule: Int? = nil,
                                 duration: Int? = nil, taskPriority: Double? = nil, scheduleStart: Int? = nil) -> Bool {
        //Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            return false
        }
        
        //argumentManager records user input for statement binding
        var argumentManager = [String]()
        
        //Conditional query strings
        //Depends on what entries of task one wants to update
        var taskTitleQueryString = ""
        if taskTitle != nil {
            taskTitleQueryString = " task_title = ?,"
            argumentManager.append(taskTitle! + "`txt")
        }
        
        //If one wants to change task description
        var taskDescQueryString = ""
        if taskDesc != nil {
            taskDescQueryString = " task_desc = ?,"
            argumentManager.append(taskDesc! + "`txt")
        }
        
        //If one wants to change category
        var categoryQueryString = ""
        if category != nil {
            categoryQueryString = " category = ?,"
            argumentManager.append(String(category!) + "`real")
        }
        
        //If one wants to change alarm
        var alarmQueryString = ""
        if alarm != nil {
            alarmQueryString = " alarm = ?,"
            argumentManager.append(String(alarm!) + "`int")
        }
        
        //If one wants to change deadline
        var deadlineQueryString = ""
        if deadline != nil {
            deadlineQueryString = " deadline = ?,"
            argumentManager.append(String(deadline!) + "`int")
        }
        
        //If one wants to change soft deadline
        var softDeadlineQueryString = ""
        if softDeadline != nil {
            softDeadlineQueryString = " soft_deadline = ?,"
            argumentManager.append(String(softDeadline!) + "`int")
        }
        
        //If one wants to change schedule
        var scheduleQueryString = ""
        if schedule != nil {
            scheduleQueryString = " schedule = ?,"
            argumentManager.append(String(schedule!) + "`int")
        }
        
        //If one wants to change duration
        var durationQueryString = ""
        if duration != nil {
            durationQueryString = " duration = ?,"
            argumentManager.append(String(duration!) + "`int")
        }
        
        //If one wants to change priority
        var priorityQueryString = ""
        if taskPriority != nil {
            priorityQueryString = " task_priority = ?,"
            argumentManager.append(String(taskPriority!) + "`real")
        }
        
        //If one wants to change scheduleStart
        var scheduleStartQueryString = ""
        if scheduleStart != nil {
            scheduleStartQueryString = " schedule_start = ?,"
            argumentManager.append(String(scheduleStart!) + "`int")
        }
        
        //last_update will always be updated
        let lastUpdateQueryString = " last_update = ?"
        
        //Concatenate the above substrings to form the query string
        let updateQueryString = "UPDATE TaskData SET" + taskTitleQueryString + taskDescQueryString +
            categoryQueryString + alarmQueryString + deadlineQueryString + softDeadlineQueryString +
            scheduleQueryString + durationQueryString + priorityQueryString + scheduleStartQueryString +
            lastUpdateQueryString + " WHERE task_id=" + String(taskId)
        
        // terminate the method if the prepare fails
        var stmt: OpaquePointer?
        if sqlite3_prepare(dbpointer, updateQueryString, -1, &stmt, nil) != SQLITE_OK {
            print("cannot prepare statements")
            return false
        }
        
        //Initialize sql statement
        //Three cases of binding
        if(argumentManager.count > 0) {
            for index in 0...argumentManager.count-1 {
                var infoAndType = argumentManager[index].split(separator: "`")
                //Array index starts at 0
                //Binding index starts at 1
                    //Case1: bind TEXT
                if infoAndType[1] == "txt" {
                    sqlite3_bind_text(stmt, Int32(index + 1), (infoAndType[0] as NSString).utf8String, -1, nil)
                }
                    //Case2: bind REAL
                else if infoAndType[1] == "real" {
                    sqlite3_bind_double(stmt, Int32(index + 1), Double(infoAndType[0])!)
                }
                    //Case3: bind INTEGER
                else if infoAndType[1] == "int" {
                    sqlite3_bind_int(stmt, Int32(index + 1), Int32(infoAndType[0])!)
                }
            }
        }
        //Bind the last argument
        let lastIndex = argumentManager.count + 1
        sqlite3_bind_int(stmt, Int32(lastIndex), Int32(Date().timeIntervalSince1970))
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            sqlite3_finalize(stmt)
            sqlite3_close(dbpointer)
            return false
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return true
    }
    
    //Delete
    //Return true for success false otherwise
    func deleteTaskFromLocalDB(taskId: Int64) -> Bool {
        //Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            return false
        }
        
        //SQL command for deleting a row from database base on taskId
        let deleteQueryString = "DELETE FROM TaskData WHERE task_id=" + String(taskId)
        
        if sqlite3_exec(dbpointer, deleteQueryString, nil, nil, nil) == SQLITE_OK {
            sqlite3_close(dbpointer)
            return true
        }
        else {
            let errmsg = String(cString: sqlite3_errmsg(dbpointer)!)
            print(errmsg)
            sqlite3_close(dbpointer)
            return false
        }
    }
}
