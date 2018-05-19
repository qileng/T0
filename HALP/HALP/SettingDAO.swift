//
//  SettingDAO.swift
//  HALP
//
//  Created by Qihao Leng on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import SQLite3

final class SettingDAO: Setting {
    
    //Create
    func saveSettingIntoLocalDB() -> Bool {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            sqlite3_close(dbpointer)
            return false
        }
        
        let settingId = self.getSettingID()
        let notification = self.isNotificationOn() == true ? 1 : 0
        let defaultView = self.getDefaultView().rawValue
        let defaultSort = self.getDefaultsort() == SortingType.priority ? "priority" : "time"
        let theme = self.getTheme()
        let avaliableDays = self.getAvailableDays()
        let startTime = self.getStartTime()
        let endTime = self.getEndTime()
        let last_update = Date().timeIntervalSince1970
        
        
        let saveQueryString = "INSERT INTO SettingData (setting_id, notification, default_view, default_sort, theme, avaliable_days, start_time, end_time, last_update) " + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"
        
        var stmt: OpaquePointer? = nil
        sqlite3_prepare(dbpointer, saveQueryString, -1, &stmt, nil)
        sqlite3_bind_int64(stmt, 1, settingId)
        sqlite3_bind_int(stmt, 2, Int32(notification))
        sqlite3_bind_text(stmt, 3, defaultView, -1, nil)
        sqlite3_bind_text(stmt, 4, defaultSort, -1, nil)
        sqlite3_bind_int64(stmt, 5, theme)
        sqlite3_bind_int(stmt, 6, avaliableDays)
        sqlite3_bind_int(stmt, 7, startTime)
        sqlite3_bind_int(stmt, 8, endTime)
        sqlite3_bind_int(stmt, 9, Int32(last_update))
        
        // Close database connection to prevent database from locking
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
    
    // Update
    func updateSettingInLocalDB(settingId: Int64, notification: Bool? = nil, defaultView: View? = nil, defaultSort: SortingType? = nil,
                                theme: Int64? = nil, availableDays: Int32? = nil, startTime: Int32? = nil, endTime: Int32? = nil) -> Bool {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            sqlite3_close(dbpointer)
            return false
        }
        
        var argumentManager = [String]()
        
        var notificationStartQueryString = ""
        if notification != nil {
            notificationStartQueryString = " notification = ?,"
            let booleanInt = notification! ? 1 : 0
            argumentManager.append(String(booleanInt) + "`int")
        }
        
        var defaultViewQueryString = ""
        if defaultView != nil {
            defaultViewQueryString = " default_view = ?,"
            argumentManager.append((defaultView?.rawValue)! + "`text")
        }
        
        var defaultSortQueryString = ""
        if defaultSort != nil {
            defaultSortQueryString = " default_sort = ?,"
            let sort  = defaultSort! == SortingType.priority ? "priority" : "time"
            argumentManager.append(sort + "`text")
        }
        
        var themeQueryString = ""
        if theme != nil {
            themeQueryString = " theme = ?,"
            argumentManager.append(String(theme!) + "`int64")
        }
        
        var availableDaysQueryString = ""
        if availableDays != nil {
            availableDaysQueryString = " avaliable_days = ?,"
            argumentManager.append(String(availableDays!) + "`int")
        }
        
        var startTimeQueryString = ""
        if startTime != nil {
            startTimeQueryString = " start_time = ?,"
            argumentManager.append(String(startTime!) + "`int")
        }
        
        var endTimeQueryString = ""
        if endTime != nil {
            endTimeQueryString = " end_time = ?,"
            argumentManager.append(String(endTime!) + "`int")
        }
        
        // last_update will always be updated
        let lastUpdateQueryString = " last_update = ?"
        
        let updateQueryString = "UPDATE TaskData SET" + notificationStartQueryString + defaultViewQueryString +
            defaultSortQueryString + themeQueryString + availableDaysQueryString + startTimeQueryString +
            endTimeQueryString + lastUpdateQueryString + " WHERE task_id=" + String(settingId)
        
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
                    
                else if infoAndType[1] == "int64" {
                    sqlite3_bind_int64(stmt, Int32(index + 1), Int64(infoAndType[0])!)
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
        sqlite3_close(dbpointer)
        return true
    }
    
    // Read
    func fetchSettingFromLocalDB(settingId: Int64) throws -> [Any] {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            throw RuntimeError.DBError("Local DB does not exist!")
        }
        
        // SQL command for fecting a row from database base on taskId
        let selectQueryString = "SELECT * FROM SettingData WHERE setting_id=" + String(settingId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [Any]()
        
        // Traverse through the row
        if sqlite3_step(stmt) == SQLITE_ROW {
            queryResult.append(sqlite3_column_int64(stmt, 0))
            queryResult.append(sqlite3_column_int(stmt, 1))
            queryResult.append(sqlite3_column_text(stmt, 2))
            queryResult.append(sqlite3_column_text(stmt, 3))
            queryResult.append(sqlite3_column_int64(stmt, 4))
            queryResult.append(sqlite3_column_int(stmt, 5))
            queryResult.append(sqlite3_column_int(stmt, 6))
            queryResult.append(sqlite3_column_int(stmt, 7))
            queryResult.append(sqlite3_column_int(stmt, 8))
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return queryResult
    }
}

