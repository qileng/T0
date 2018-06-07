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
    
    // Create a new task in local database, associated with a user
    // Return true for success, false otherwise
    func saveTaskInfoToLocalDB() -> Bool {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
			sqlite3_close(dbpointer)
            return false
        }
        
        // SQL command to insert into TaskData table
        let insertQueryString = "INSERT INTO TaskData " +
        "(task_id, task_title, task_desc, category, alarm, deadline, soft_deadline, schedule, duration, task_priority, schedule_start, notification, user_id, last_update) " +
        "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

        let taskId = self.getTaskId()
        let userId = self.getUserId()
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
        //Store boolean as int
        let notification = self.getNotification() ? 1 : 0
        let last_update = Date().timeIntervalSince1970
        
        // statement for entry binding
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
        sqlite3_bind_int(stmt, 12, Int32(notification))
        sqlite3_bind_int64(stmt, 13, userId)
        sqlite3_bind_int(stmt, 14, Int32(last_update))
        
        // Close database connection to prevent database from locking
        if sqlite3_step(stmt) == SQLITE_DONE {
            
            // update user last_update timestamp
            do {
                let DAO = TaskDAO()
                let userInfo = try DAO.fetchTaskInfoFromLocalDB(taskId: taskId)
                if userInfo["user_id"] == nil {
                    return false
                }
                let userId = userInfo["user_id"] as! Int64
                let userDAO = UserDAO()
                let updateuser = try userDAO.fetchUserInfoFromLocalDB(userId: userId)
                if updateuser.count != 5 {
                    return false
                }
                _ = userDAO.updateUserInfoInLocalDB(userId: userId, username: (updateuser[1] as! String),
                                                    password: (updateuser[2] as! String), email: (updateuser[3] as! String))
            } catch {
                return false
            }
            
            sqlite3_close(dbpointer)
            
            if !updateSummaryRecord(taskId: taskId, isCreate: true) {
                return false
            }
            
            return true
        } else {
            let _ = String(cString: sqlite3_errmsg(dbpointer)!)
            sqlite3_close(dbpointer)
            return false
        }
    }
    
    // Read a single task
    func fetchTaskInfoFromLocalDB(taskId: Int64) throws -> Dictionary<String, Any> {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            throw RuntimeError.DBError("Local DB does not exist!")
        }
        
        // SQL command for fecting a row from database base on taskId
        let selectQueryString = "SELECT * FROM TaskData WHERE task_id=" + String(taskId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [String : Any]()
        let keys = ["task_id", "task_title", "task_desc", "category", "alarm", "deadline", "soft_deadline", "schedule", "duration", "task_priority", "scheduled_start", "notification", "user_id", "last_update"]
        var values = [Any]()
        
        // Traverse through the row
        if sqlite3_step(stmt) == SQLITE_ROW {
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
            let notification = sqlite3_column_int(stmt, 11)
            let user_id = sqlite3_column_int64(stmt, 12)
            let last_update = sqlite3_column_int(stmt, 13)
            values.append(taskId)
            values.append(title)
            values.append(description)
            values.append(category)
            values.append(alarm)
            values.append(deadline)
            values.append(softDeadline)
            values.append(schedule)
            values.append(during)
            values.append(priority)
            values.append(scheduleStart)
            values.append(notification)
            values.append(user_id)
            values.append(last_update)
            queryResult = Dictionary(uniqueKeysWithValues: zip(keys, values))
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return queryResult
    }
    
    // Read a list of taskId associated with a user
    func fetchTaskIdListFromLocalDB(userId: Int64) throws -> [Int64] {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            throw RuntimeError.DBError("Local DB does not exist!")
        }
        
        // SQL command for fecting a row from database base on taskId
        let selectQueryString = "SELECT task_id FROM TaskData WHERE user_id=" + String(userId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [Int64]()
        
        // Traverse through the specific row
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
                                 duration: Int? = nil, taskPriority: Double? = nil, scheduleStart: Int? = nil, notification: Bool? = nil) -> Bool {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
			sqlite3_close(dbpointer)
            return false
        }
        
        // argumentManager records user input for statement binding
        var argumentManager = [String]()
        
        // Conditional query strings
        // Depends on what entries of task one wants to update
        var taskTitleQueryString = ""
        if taskTitle != nil {
            taskTitleQueryString = " task_title = ?,"
            argumentManager.append(taskTitle! + " `txt")
        }
        
        // If one wants to change task description
        var taskDescQueryString = ""
        if taskDesc != nil {
            taskDescQueryString = " task_desc = ?,"
            argumentManager.append(taskDesc! + " `txt")
        }
        
        // If one wants to change category
        var categoryQueryString = ""
        if category != nil {
            categoryQueryString = " category = ?,"
            argumentManager.append(String(category!) + "`real")
        }
        
        // If one wants to change alarm
        var alarmQueryString = ""
        if alarm != nil {
            alarmQueryString = " alarm = ?,"
            argumentManager.append(String(alarm!) + "`int")
        }
        
        // If one wants to change deadline
        var deadlineQueryString = ""
        if deadline != nil {
            deadlineQueryString = " deadline = ?,"
            argumentManager.append(String(deadline!) + "`int")
        }
        
        // If one wants to change soft deadline
        var softDeadlineQueryString = ""
        if softDeadline != nil {
            softDeadlineQueryString = " soft_deadline = ?,"
            argumentManager.append(String(softDeadline!) + "`int")
        }
        
        // If one wants to change schedule
        var scheduleQueryString = ""
        if schedule != nil {
            scheduleQueryString = " schedule = ?,"
            argumentManager.append(String(schedule!) + "`int")
        }
        
        // If one wants to change duration
        var durationQueryString = ""
        if duration != nil {
            durationQueryString = " duration = ?,"
            argumentManager.append(String(duration!) + "`int")
        }
        
        // If one wants to change priority
        var priorityQueryString = ""
        if taskPriority != nil {
            priorityQueryString = " task_priority = ?,"
            argumentManager.append(String(taskPriority!) + "`real")
        }
        
        // If one wants to change scheduleStart
        var scheduleStartQueryString = ""
        if scheduleStart != nil {
            scheduleStartQueryString = " schedule_start = ?,"
            argumentManager.append(String(scheduleStart!) + "`int")
        }
        
        // If one wants to change notification setting
        var notificationStartQueryString = ""
        if notification != nil {
            notificationStartQueryString = " notification = ?,"
            let booleanInt = notification! ? 1 : 0
            argumentManager.append(String(booleanInt) + "`int")
        }
        
        // last_update will always be updated
        let lastUpdateQueryString = " last_update = ?"
        
        // Concatenate the above substrings to form the query string
        let updateQueryString = "UPDATE TaskData SET" + taskTitleQueryString + taskDescQueryString +
            categoryQueryString + alarmQueryString + deadlineQueryString + softDeadlineQueryString +
            scheduleQueryString + durationQueryString + priorityQueryString + scheduleStartQueryString +
            notificationStartQueryString + lastUpdateQueryString + " WHERE task_id=" + String(taskId)
        
        // terminate the method if the prepare fails
        var stmt: OpaquePointer?
        if sqlite3_prepare(dbpointer, updateQueryString, -1, &stmt, nil) != SQLITE_OK {
            print("cannot prepare statements")
			sqlite3_close(dbpointer)
            return false
        }
        
        // Initialize sql statement
        // Three cases of binding
        if(argumentManager.count > 0) {
            for index in 0...argumentManager.count-1 {
                var infoAndType = argumentManager[index].split(separator: "`")
                // Array index starts at 0
                // Binding index starts at 1
                    // Case1: bind TEXT
                if infoAndType[1] == "txt" {
                    sqlite3_bind_text(stmt, Int32(index + 1), (infoAndType[0] as NSString).utf8String, -1, nil)
                }
                    // Case2: bind REAL
                else if infoAndType[1] == "real" {
                    sqlite3_bind_double(stmt, Int32(index + 1), Double(infoAndType[0])!)
                }
                    // Case3: bind INTEGER
                else if infoAndType[1] == "int" {
                    sqlite3_bind_int(stmt, Int32(index + 1), Int32(infoAndType[0])!)
                }
            }
        }
        // Bind the last argument
        let lastIndex = argumentManager.count + 1
        sqlite3_bind_int(stmt, Int32(lastIndex), Int32(Date().timeIntervalSince1970))
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            sqlite3_finalize(stmt)
            sqlite3_close(dbpointer)
            return false
        }
        sqlite3_finalize(stmt)
        
        // update user last_update timestamp
        do {
            let DAO = TaskDAO()
            
            let userInfo = try DAO.fetchTaskInfoFromLocalDB(taskId: taskId)
            if userInfo["user_id"] == nil {
                return false
            }
            let userId = userInfo["user_id"] as! Int64
            
            let userDAO = UserDAO()
            let updateuser = try userDAO.fetchUserInfoFromLocalDB(userId: userId)
            if updateuser.count != 5 {
                return false
            }
            _ = userDAO.updateUserInfoInLocalDB(userId: userId, username: (updateuser[1] as! String),
                                                password: (updateuser[2] as! String), email: (updateuser[3] as! String))
        } catch {
            return false
        }
        
        sqlite3_close(dbpointer)
        return true
    }
    
    // Delete
    // Return true for success false otherwise
    func deleteTaskFromLocalDB(taskId: Int64) -> Bool {
        //Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
			sqlite3_close(dbpointer)
            return false
        }
        
        // update user last_update timestamp
        do {
            let DAO = TaskDAO()
            let userInfo = try DAO.fetchTaskInfoFromLocalDB(taskId: taskId)
            if userInfo["user_id"] == nil {
                return false
            }
//
//            if !updateSummaryRecord(taskId: taskId, isCreate: false) {
//                return false
//            }
			
            let userId = userInfo["user_id"] as! Int64
            let userDAO = UserDAO()
            let updateuser = try userDAO.fetchUserInfoFromLocalDB(userId: userId)
            if updateuser.count != 5 {
                return false
            }
            _ = userDAO.updateUserInfoInLocalDB(userId: userId, username: (updateuser[1] as! String),
                                                password: (updateuser[2] as! String), email: (updateuser[3] as! String))
        } catch {
            print("update_user fail")
            return false
        }
        
        
        
        // SQL statement for deleting a row from database base on taskId
        let deleteQueryString = "DELETE FROM TaskData WHERE task_id=" + String(taskId)
        
        if sqlite3_exec(dbpointer, deleteQueryString, nil, nil, nil) == SQLITE_OK {
            sqlite3_close(dbpointer)
            return true
        }
        else {
            let _ = String(cString: sqlite3_errmsg(dbpointer)!)
            sqlite3_close(dbpointer)
            return false
        }
    }
}


// Helper method
// Record user last update timestamp
func updateSummaryRecord(taskId: Int64, isCreate: Bool) -> Bool {
    //Default local database path
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
    var dbpointer: OpaquePointer?
    
    if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
        print("fail to establish databse connection")
        sqlite3_close(dbpointer)
        return false
    }

    do {
        var categoryFlag: Category
        let DAO = TaskDAO()
        let userInfo = try DAO.fetchTaskInfoFromLocalDB(taskId: taskId)
        categoryFlag = Category(rawValue: (userInfo["category"] as! Double))!
        if userInfo["user_id"] == nil {
            return false
        }
        
        let userId = userInfo["user_id"] as! Int64
        let settingDAO = SettingDAO()
        let updateSummary = try settingDAO.fetchSettingFromLocalDB(settingId: userId)
        if updateSummary.count != 9 {
            return false
        }

        // Update summary string
        // Split the string into 8 substrings
        var summaryString = updateSummary[2] as! String
        var summaryValueList = summaryString.split(separator: ",")
        
        if categoryFlag == Category.Study_Work {
            if isCreate {
                let increment = Int(String(summaryValueList[0]))! + 1
                summaryValueList[0] = Substring(String(increment))
            }
            else {
                let increment = Int(String(summaryValueList[1]))! + 1
                summaryValueList[1] = Substring(String(increment))
            }
        } else if categoryFlag == Category.Chore {
            if isCreate {
                let increment = Int(String(summaryValueList[2]))! + 1
                summaryValueList[2] = Substring(String(increment))
            }
            else {
                let increment = Int(String(summaryValueList[3]))! + 1
                summaryValueList[3] = Substring(String(increment))
            }
        } else if categoryFlag == Category.Relationship {
            if isCreate {
                let increment = Int(String(summaryValueList[4]))! + 1
                summaryValueList[4] = Substring(String(increment))
            }
            else {
                let increment = Int(String(summaryValueList[5]))! + 1
                summaryValueList[5] = Substring(String(increment))
            }
        } else if categoryFlag == Category.Entertainment {
            if isCreate {
                let increment = Int(String(summaryValueList[6]))! + 1
                summaryValueList[6] = Substring(String(increment))
            }
            else {
                let increment = Int(String(summaryValueList[7]))! + 1
                summaryValueList[7] = Substring(String(increment))
            }
        }
        
        summaryString = ""
        for subString in summaryValueList {
            summaryString = summaryString + subString + ","
        }
        summaryString = String(summaryString.dropLast())


        // Update setting info in task manager
        let settingArray = updateSummary
        let settingId = settingArray[0] as! Int64
        let notification = settingArray[1] as! Int32 == 1 ? true : false
        let summary = summaryString
        let sort = settingArray[3] as! Int32 == 1 ? SortingType.priority : SortingType.time
        let theme = settingArray[4] as! Int32 == 1 ? Theme.dark : Theme.regular
        let avaliableDays = settingArray[5] as! Int32
        let start = settingArray[6] as! Int32
        let end = settingArray[7] as! Int32
        
        let userSetting = Setting(setting: settingId, notification: notification, theme: theme,
                                  summary: summary, defaultSort: sort, availableDays: avaliableDays, startTime: start,
                                  endTime: end, user: settingId)
    

       TaskManager.sharedTaskManager.updateSetting(setting: userSetting)
    
    } catch {
        sqlite3_close(dbpointer)
        return false
    }
    sqlite3_close(dbpointer)
    return true
}
