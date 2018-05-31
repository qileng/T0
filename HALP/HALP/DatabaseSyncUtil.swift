//
//  DatabaseSyncUtil.swift
//  HALP
//
//  Created by FlikHu on 5/27/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import SQLite3
import FirebaseCore

// New sync function
// Take an user id as argument
func syncDatabase(userId: Int64, completion: @escaping (Bool) -> Void) {
    
    // Establish connection to both local and online database
    let firebaseRef = Database.database().reference()
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
    var dbpointer: OpaquePointer?
    if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
        print("fail to establish database connection")
        completion(false)
        sqlite3_close(dbpointer)
    }
    
    // tableFlag: 1, compare local and online setting
    compareDate(tableFlag: 1, id: userId, completion: { (last_update_flag) in
        // Local newer
        if last_update_flag == 0 {
            
            // Get local setting
            let settingQueryDAO = SettingDAO()
            var SettingData: Dictionary<String, Any>
            let settingKey = ["setting_id", "notification", "default_view", "default_sort", "theme", "avaliable_days", "start_time", "end_time", "last_update"]
            var settingValue = [Any]()
            do {
                settingValue = try settingQueryDAO.fetchSettingFromLocalDB(settingId: userId)
            } catch {
                print("Error fetching setting info")
            }
            if settingValue.count == 9 {
                settingValue[8] = Int32(Date().timeIntervalSince1970)
            }
            SettingData = Dictionary(uniqueKeysWithValues: zip(settingKey, settingValue))
            
            // Overwrite online setting
            print("settin local to online")
            firebaseRef.child("SettingData").child(String(userId)).setValue(SettingData)
            
        }
        // Online newer
        else if last_update_flag == 1 {
            // Get online setting
            firebaseRef.child("SettingData").child(String(userId)).observeSingleEvent(of: .value, with: {(data) in
                print("settin online to local")
                let dict = data.value as! [String : Any]
                print(dict)
                let notification = dict["notification"] as! Int32 == 1 ? true : false
                let theme = dict["theme"] as! Int32 == 1 ? Theme.dark : Theme.regular
                let view = dict["default_view"] as! Int32 == 1 ? View.list : View.clock
                let sort = dict["default_sort"] as! Int32 == 1 ? SortingType.priority : SortingType.time
            
                let settingQueryDAO = SettingDAO(setting: dict["setting_id"] as! Int64, notification: notification,
                                             theme: theme, defaultView: view, defaultSort: sort,
                                             availableDays: dict["avaliable_days"] as! Int32,
                                             startTime: dict["start_time"] as! Int32, endTime: (dict["end_time"] as! Int32),
                                             user: dict["setting_id"] as! Int64)
            
                // Don't know if the setting exist in local database
                // First try saving into local database
                if !settingQueryDAO.saveSettingIntoLocalDB() {
                    // If fails (duplciate entries), use update function
                    _ = settingQueryDAO.updateSettingInLocalDB(settingId: dict["setting_id"] as! Int64,
                                                           notification: notification,
                                                           defaultView: view,
                                                           defaultSort: sort, theme: theme,
                                                           availableDays: (dict["avaliable_days"] as! Int32),
                                                           startTime:  (dict["start_time"] as! Int32),
                                                           endTime: (dict["end_time"] as! Int32))
                }
            })
        }
        
        // Callback No.1
        // tableFlag: 0, compare local and online user
        compareDate(tableFlag: 0, id: userId, completion: { (last_update_flag) in
            // Local newer
            if last_update_flag == 0 {
                // Get local user
                let userQueryDAO = UserDAO()
                var UserData: Dictionary<String, Any>
                let userKey = ["user_id", "user_name", "password", "email", "last_update"]
                var userValue = [Any]()
                do {
                    userValue = try userQueryDAO.fetchUserInfoFromLocalDB(userId: userId)
                } catch {
                    print("Error fetching user info")
                }
                if userValue.count == 5 {
                    userValue[4] = Int32(Date().timeIntervalSince1970)
                }
                UserData = Dictionary(uniqueKeysWithValues: zip(userKey, userValue))
                print("user local to online")
                // Overwrite online user
                firebaseRef.child("UserData").child(String(userId)).setValue(UserData)
                
                // Erase the old copy
                firebaseRef.child("TaskData").queryOrdered(byChild: "user_id").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: { (data) in
                    for child in data.children.allObjects as! [DataSnapshot] {
                        firebaseRef.child("TaskData").child(child.key).removeValue()
                    }
                    
                    // Get local tasks associated with the user
                    let taskQueryDAO = TaskDAO()
                    var associatedTasks = [Int64]()
                    do {
                        associatedTasks = try taskQueryDAO.fetchTaskIdListFromLocalDB(userId: userId)
                    } catch {
                        print("Error fetching task list")
                    }
                    
                    if associatedTasks.count != 0 {
                        for index in 0...associatedTasks.count-1 {
                            var task: Dictionary<String, Any> = ["":""]
                            do {
                                task = try taskQueryDAO.fetchTaskInfoFromLocalDB(taskId: associatedTasks[index])
                            } catch {
                                print("Error fetching task info")
                            }
                            
                            // Overwrite online tasks
                            print("task local to online")
                            task["last_update"] = Int32(Date().timeIntervalSince1970)
                            firebaseRef.child("TaskData").child(String(associatedTasks[index])).setValue(task)
                        }
                    }
                    completion(true)
                })
            }
            // Online newer
            else if last_update_flag == 1 {
                // Get online user
                // Firebase query is an async function
                // Need to Wrap every thing in callback
                firebaseRef.child("UserData").child(String(userId)).observeSingleEvent(of: .value, with: { (data) in
                    
                    let dict = data.value as! [String : Any]
                    print("user online to local")
                    let userQueryDAO = UserDAO(username: dict["user_name"] as! String, password: dict["password"] as! String, email: dict["email"] as! String, id: userId)
                    
                    if !userQueryDAO.saveUserInfoToLocalDB() {
                        _ = userQueryDAO.updateUserInfoInLocalDB(userId: userId, username: (dict["user_name"] as! String),
                                                                 password: (dict["password"] as! String), email: (dict["email"] as! String))
                    }
                    
                    // Get online tasks and insert into local database
                    // First remove old tasks from local database
                    let taskQueryDAO = TaskDAO()
                    do {
                        let oldTasks = try taskQueryDAO.fetchTaskIdListFromLocalDB(userId: userId)
                        for taskId in oldTasks {
                            taskQueryDAO.deleteTaskFromLocalDB(taskId: taskId)
                        }
                    } catch {
                        print("cannot delete task")
                    }
                    
                    firebaseRef.child("TaskData").queryOrdered(byChild: "user_id").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: { (data) in
                        
                        let taskCount = data.childrenCount
                        var counter = 0
                        for child in data.children.allObjects as! [DataSnapshot] {
                            let dict = child.value as! [String : Any]
                            print("task online to local")
                            let taskQueryDAO = TaskDAO(dict)
                            
                            // Don't know if the tasks exist in local database
                            // First try saving into local database
                            if !taskQueryDAO.saveTaskInfoToLocalDB() {
                                // If fails (duplciate entries), use update function
                                _ = taskQueryDAO.updateTaskInfoInLocalDB(taskId: dict["task_id"] as! Int64,
                                                                         taskTitle: (dict["task_title"] as! String),
                                                                         taskDesc: (dict["task_desc"] as! String),
                                                                         category: (dict["category"] as! Double),
                                                                         alarm: (dict["alarm"] as! Int),
                                                                         deadline: (dict["deadline"] as! Int),
                                                                         softDeadline: (dict["soft_deadline"]! as! Int),
                                                                         schedule: (dict["schedule"] as! Int),
                                                                         duration: (dict["duration"] as! Int),
                                                                         taskPriority: (dict["task_priority"] as! Double),
                                                                         scheduleStart: (dict["scheduled_start"] as! Int),
                                                                         notification: (dict["notification"] as! Int) == 1 ? true : false)
                            }
//                            print("local counter", counter, taskCount)
                            counter = counter + 1
                            if counter == taskCount {
                                completion(true)
                            }
                        }
                        completion(true)
                    })
                })
            }
        })
    })
}

// Generic helper function
// compare last_update
// tableFlag indicates which table the comparison should occur
// 0: user, 1: setting
// id is the id of the object for local/online db comparison
// return 0 if local db is more up to date, 1 otherwiseb and -1 if data does not exist
// return int flag stored in completion handler, need to catch with callback
func compareDate(tableFlag: Int, id: Int64, completion: @escaping (Int) -> ()){
    // Establish online database connection
    let firebaseRef = Database.database().reference()
    let userQueryDAO = UserDAO()
    let settingQueryDAO = SettingDAO()
    let dbTableRef = ["UserData", "SettingData"]
    let infoArrayLength = [5, 9]
    var returnFlag = -1
    
        // Online
        // Observe event is async
        // Have to wrap all the code in the callback
        var onlineLastUpdate: Int32 = -1
        firebaseRef.child(dbTableRef[tableFlag]).child(String(id)).child("last_update").observeSingleEvent(
        of: .value, with: {(data) in
            // if the data does not exist in the online db
            // local database is newer
            if data.value is NSNull {
                onlineLastUpdate = -1
            }
            else {
                onlineLastUpdate = data.value as! Int32
            }
            
            // Local
            var localLastUpdate: Int32 = -1
            do {
                var data = [Any]()
                
                // User
                if tableFlag == 0 {
                    data = try userQueryDAO.fetchUserInfoFromLocalDB(userId: id)
                }
                // Setting
                else if tableFlag == 1 {
                    data = try settingQueryDAO.fetchSettingFromLocalDB(settingId: id)
                }
                
                // Make sure the local data is not empty
                if data.count == infoArrayLength[tableFlag] {
                    localLastUpdate = data[infoArrayLength[tableFlag] - 1] as! Int32
                }
                else {
                    localLastUpdate = -1
                }
                
            } catch {
                print("Error reading local database")
            }
            
            print("local ", localLastUpdate, "online", onlineLastUpdate)
            
            if localLastUpdate >= onlineLastUpdate {
                returnFlag = 0
            } else {
                returnFlag = 1
            }
            
            
            // invalid comparison if the object does not exist
            if localLastUpdate < 0 && onlineLastUpdate < 0 {
                returnFlag = -1
            }
            completion(returnFlag)
        }
    )

}

