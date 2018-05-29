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

// for the sync button in setting
private func syncLocalToFirebase(userId: Int64, completion: @escaping (Bool) -> Void) {
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
    var dbpointer: OpaquePointer?
    
    // Establish local database connection
    if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
        print("fail to establish database connection")
        sqlite3_close(dbpointer)
    }
    
    let userQueryDAO = UserDAO()
    let settingQueryDAO = SettingDAO()
    let taskQueryDAO = TaskDAO()
    
    // Firebase query methods take dictionaries as arguments
    // User
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
    
    // Setting
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
    
    // Task
    // First get task list
    var associatedTasks = [Int64]()
    do {
        associatedTasks = try taskQueryDAO.fetchTaskIdListFromLocalDB(userId: userId)
    } catch {
        print("Error fetching task list")
    }
    
    // Establish online database connection
    let firebaseRef = Database.database().reference()
    
    // User
    compareDate(tableFlag: 0, id: userId, completion: { flag in
        if(flag == 0) {
            print("user local to online")
            firebaseRef.child("UserData").child(String(userId)).setValue(UserData)
        }
        
        // Chaining asycn functions
        // Setting
        compareDate(tableFlag: 1, id: userId, completion: { (flag) in
            if(flag == 0) {
                print("settin local to online")
                firebaseRef.child("SettingData").child(String(userId)).setValue(SettingData)
            }
            // Task
            // push every associated task into online db (in the form of dictionary)
            var counter = 0
            var taskCount = associatedTasks.count
            if associatedTasks.count != 0 {
                for index in 0...associatedTasks.count-1 {
                    var task: Dictionary<String, Any> = ["":""]
                    do {
                        task = try taskQueryDAO.fetchTaskInfoFromLocalDB(taskId: associatedTasks[index])
                    } catch {
                        print("Error fetching task info")
                    }
                    
                    compareDate(tableFlag: 2, id: associatedTasks[index], completion: { (flag) in
                        counter = counter + 1
                        if(flag == 0) {
                            print("task local to online")
                            task["last_update"] = Int32(Date().timeIntervalSince1970)
                            firebaseRef.child("TaskData").child(String(associatedTasks[index])).setValue(task)
                        }
                        if counter == taskCount {
                            completion(true)
                        }
                    })
                }
            } else {
                completion(true)
            }
            
        })
    })
}

private func syncFirebaseToLocal(userId: Int64, completion: @escaping (Bool) -> Void) {
    let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
    var dbpointer: OpaquePointer?
    
    // Establish local database connection
    if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
        print("fail to establish database connection")
        sqlite3_close(dbpointer)
    }

    let firebaseRef = Database.database().reference()
    
    // User
    firebaseRef.child("UserData").child(String(userId)).observeSingleEvent(of: .value, with: {(data) in
    
        let dict: [String: Any]
        if data.value is NSNull {
            dict = ["":""]
        }
        else {
            dict = data.value as! [String: Any]
        }
        
        compareDate(tableFlag: 0, id: userId, completion:{(flag) in
            if(flag == 1) {
                print("user online to local")
                let userQueryDAO = UserDAO(username: dict["user_name"] as! String, password: dict["password"] as! String, email: dict["email"] as! String, id: userId)
                
                if !userQueryDAO.saveUserInfoToLocalDB() {
                    userQueryDAO.updateUserInfoInLocalDB(userId: userId, username: dict["user_name"] as! String,
                                                         password: dict["password"] as! String, email: dict["email"] as! String)
                }
            }
        })
        
        // Setting
        firebaseRef.child("SettingData").child(String(userId)).observeSingleEvent(of: .value, with: {(data) in
            
            let dict: [String: Any]
            if data.value is NSNull {
                dict = ["":""]
            }
            else {
                dict = data.value as! [String: Any]
            }
            
            compareDate(tableFlag: 1, id: userId, completion:{(flag) in
                if(flag == 1) {
                    print("settin online to local")
                    
                    let notification = dict["notification"] as! Int32 == 1 ? true : false
                    let theme = dict["theme"] as! Int32 == 1 ? Theme.dark : Theme.regular
                    let view = dict["default_view"] as! Int32 == 1 ? View.list : View.clock
                    let sort = dict["default_sort"] as! Int32 == 1 ? SortingType.priority : SortingType.time
                    
                    let settingQueryDAO = SettingDAO(setting: dict["setting_id"] as! Int64, notification: notification,
                                                     theme: theme, defaultView: view, defaultSort: sort,
                                                     availableDays: dict["avaliable_days"] as! Int32,
                                                     startTime: dict["start_time"] as! Int32, endTime: (dict["end_time"] as! Int32),
                                                     user: dict["setting_id"] as! Int64)
                    
                    if !settingQueryDAO.saveSettingIntoLocalDB() {
                        settingQueryDAO.updateSettingInLocalDB(settingId: dict["setting_id"] as! Int64,
                                                               notification: notification,
                                                               defaultView: view,
                                                               defaultSort: sort, theme: theme,
                                                               availableDays: dict["avaliable_days"] as! Int32,
                                                               startTime:  (dict["start_time"] as! Int32),
                                                               endTime: (dict["end_time"] as! Int32))
                    }
                }
                
                // Task
                firebaseRef.child("TaskData").queryOrdered(byChild: "user_id").queryEqual(toValue: userId).observeSingleEvent(of: .value, with: {(data) in
                    
                    var taskCount = data.childrenCount
                    var counter = 0
                    for child in data.children.allObjects as! [DataSnapshot] {
                        
                        let dict: [String: Any]
                        if child.value is NSNull {
                            dict = ["":""]
                        }
                        else {
                            dict = child.value as! [String: Any]
                        }
                        print(dict)
                        compareDate(tableFlag: 2, id: dict["task_id"] as! Int64, completion:{(flag) in
                            counter = counter + 1
                            if(flag == 1) {
                                print("task online to local")
                                let taskQueryDAO = TaskDAO(dict)
                                
                                if !taskQueryDAO.saveTaskInfoToLocalDB() {
                                    taskQueryDAO.updateTaskInfoInLocalDB(taskId: dict["task_id"] as! Int64,
                                                                         taskTitle: (dict["task_title"] as! String),
                                                                         taskDesc: (dict["task_desc"] as! String),
                                                                         category: (dict["category"] as! Double),
                                                                         alarm: dict["alarm"] as! Int,
                                                                         deadline: (dict["deadline"] as! Int),
                                                                         softDeadline: dict["soft_deadline"]! as! Int,
                                                                         schedule: (dict["schedule"] as! Int),
                                                                         duration: (dict["duration"] as! Int),
                                                                         taskPriority: (dict["task_priority"] as! Double),
                                                                         scheduleStart: (dict["scheduled_start"] as! Int),
                                                                         notification: (dict["notification"] as! Int) == 1 ? true : false)
                                }
                            }

                            if counter == taskCount {
                                completion(true)
                            }
                        })

                    }
                    completion(true)
                })
            })
            
        })
    })
}


// Call this method
func dbSync(userId: Int64, completion: @escaping (Bool) -> Void) {
    print("local -> firebase \n")
    syncLocalToFirebase(userId: userId, completion: {(flag) in
        if flag {
            print("firebase -> local \n")
            syncFirebaseToLocal(userId: userId, completion: {(flag) in
                if flag {
                    completion(true)
                }
            })
        }
    })
}

// Generic helper function
// compare last_update
// tableFlag indicates which table the comparison should occur
// 0: user, 1: setting, 2: task
// id is the id of the object for local/online db comparison
// return 0 if local db is more up to date, 1 otherwiseb and -1 if data does not exist
// return int flag stored in completion handler, need to catch with callback
func compareDate(tableFlag: Int, id: Int64, completion: @escaping (Int) -> ()){
    // Establish online database connection
    let firebaseRef = Database.database().reference()
    let userQueryDAO = UserDAO()
    let settingQueryDAO = SettingDAO()
    let taskQueryDAO = TaskDAO()
    let dbTableRef = ["UserData", "SettingData", "TaskData"]
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
                var taskData: Dictionary<String, Any>
                
                // User
                if tableFlag == 0 {
                    data = try userQueryDAO.fetchUserInfoFromLocalDB(userId: id)
                    if data.count == 5 {
                        localLastUpdate = data[4] as! Int32
                    }
                    else {
                        localLastUpdate = -1
                    }
                } else if tableFlag == 1 {
                    data = try settingQueryDAO.fetchSettingFromLocalDB(settingId: id)
                    if data.count == 9 {
                        localLastUpdate = data[8] as! Int32
                    }
                    else {
                        localLastUpdate = -1
                    }
                }
                else if tableFlag == 2 {
                    taskData = try taskQueryDAO.fetchTaskInfoFromLocalDB(taskId: id)
                    if taskData["last_update"] != nil {
                        localLastUpdate = taskData["last_update"] as! Int32
                    }
                    else {
                        localLastUpdate = -1
                    }
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

