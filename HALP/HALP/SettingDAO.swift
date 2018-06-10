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

        // Initialize all the database access object
        let settingId = self.getSettingID()
        let notification = self.isNotificationOn() == true ? 1 : 0
        let summary = self.getSummary() as NSString
        let defaultSort = self.getDefaultSort().rawValue
        let theme = self.getTheme().rawValue
        let avaliableDays = self.getAvailableDays()
        let startTime = self.getStartTime()
        let endTime = self.getEndTime()
        let last_update = Date().timeIntervalSince1970
        
        
        let saveQueryString = "INSERT INTO SettingData (setting_id, notification, default_view, default_sort, theme, avaliable_days, start_time, end_time, last_update) " + "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)"

        // Prepare SQL statement
        var stmt: OpaquePointer? = nil
        sqlite3_prepare(dbpointer, saveQueryString, -1, &stmt, nil)
        sqlite3_bind_int64(stmt, 1, settingId)
        sqlite3_bind_int(stmt, 2, Int32(notification))
        sqlite3_bind_text(stmt, 3, summary.utf8String, -1, nil)
        sqlite3_bind_int(stmt, 4, Int32(defaultSort))
        sqlite3_bind_int(stmt, 5, Int32(theme))
        sqlite3_bind_int(stmt, 6, avaliableDays)
        sqlite3_bind_int(stmt, 7, startTime)
        sqlite3_bind_int(stmt, 8, endTime)
        sqlite3_bind_int(stmt, 9, Int32(last_update))
        
        // Close database connection to prevent database from locking
        if sqlite3_step(stmt) == SQLITE_DONE {
            sqlite3_close(dbpointer)
            return true
        } else {
			_ = String(cString: sqlite3_errmsg(dbpointer)!)
            sqlite3_close(dbpointer)
            return false
        }
    }
    
    // Update function for user setting
    // All arguments are optional
    func updateSettingInLocalDB(settingId: Int64, notification: Bool? = nil, Summary: String? = nil, defaultSort: SortingType? = nil,
                                theme: Theme? = nil, availableDays: Int32? = nil, startTime: Int32? = nil, endTime: Int32? = nil) -> Bool {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            sqlite3_close(dbpointer)
            return false
        }

        // Remember input arguments
        var argumentManager = [String]()
        
        var notificationStartQueryString = ""
        if notification != nil {
            notificationStartQueryString = " notification = ?,"
            let booleanInt = notification! ? 1 : 0
            argumentManager.append(String(booleanInt) + "`int")
        }
        
        var defaultViewQueryString = ""
        if Summary != nil {
            defaultViewQueryString = " default_view = ?,"
            argumentManager.append(Summary! + "`txt")
        }
        
        var defaultSortQueryString = ""
        if defaultSort != nil {
            defaultSortQueryString = " default_sort = ?,"
            argumentManager.append(String(defaultSort!.rawValue) + "`int")
        }
        
        var themeQueryString = ""
        if theme != nil {
            themeQueryString = " theme = ?,"
            argumentManager.append(String(theme!.rawValue) + "`int")
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
        
        let updateQueryString = "UPDATE SettingData SET" + notificationStartQueryString + defaultViewQueryString +
            defaultSortQueryString + themeQueryString + availableDaysQueryString + startTimeQueryString +
            endTimeQueryString + lastUpdateQueryString + " WHERE setting_id=" + String(settingId)
        
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
                    // Case2: bind INTEGER
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
        sqlite3_close(dbpointer)
        return true
    }
    
    // Read function for user setting
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
            queryResult.append(String(cString: sqlite3_column_text(stmt, 2)))
            queryResult.append(sqlite3_column_int(stmt, 3))
            queryResult.append(sqlite3_column_int(stmt, 4))
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

