//
//  AppDelegate.swift
//  HALP
//

//  Created by Qihao Leng Haozhi Flik Huon Zach Sun 4/27/18.

//  Copyright © 2018 Team Zero. All rights reserved.
//
//  Anagha - test for pushing to github <<DELETE THIS>>
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    var firebaseRef: DatabaseReference?
    
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        // Initialize local database
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = documentsPath + "/appData.sqlite"
        print(dbPath)
        var dbpointer: OpaquePointer? = nil
        
        //Comment this out later
        //        sqlite3_open(dbPath, &dbpointer)
        //        sqlite3_exec(dbpointer, "DROP TABLE UserData", nil, nil, nil)
        //        sqlite3_exec(dbpointer, "DROP TABLE TaskData", nil, nil, nil)
        //        sqlite3_exec(dbpointer, "DROP TABLE SettingData", nil, nil, nil)
        //        sqlite3_close(dbpointer)
        
        if sqlite3_open(dbPath, &dbpointer) == SQLITE_OK {
            // UserData table
            firebaseRef = Database.database().reference()
            
            // sqlite3_exec(dbpointer, "DROP TABLE UserData", nil, nil, nil)
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS UserData" +
                "(user_id INTEGER PRIMARY KEY, user_name TEXT, password TEXT, email TEXT, last_update INTEGER)", nil, nil, nil)
            // Initialize guest account
            sqlite3_exec(dbpointer, "INSERT INTO UserData (user_id, user_name, password, email, last_update) " +
                "VALUES (0, 'GUEST', 'GUEST', 'GUEST@GUEST.com', 0)", nil , nil, nil)
            
            // TaskData table
            // sqlite3_exec(dbpointer, "DROP TABLE TaskData", nil, nil, nil)
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS TaskData" +
                "(task_id INTEGER PRIMARY KEY, task_title TEXT, task_desc TEXT, " +
                "category REAL, alarm INTEGER, deadline INTEGER, soft_deadline INTEGER, schedule INTEGER, duration INTEGER, " +
                "task_priority REAL, schedule_start INTEGER, notification INTEGER, user_id INTEGER, last_update INTEGER)", nil, nil, nil)
            
            // SettingData table not yet implemented
            // sqlite3_exec(dbpointer, "DROP TABLE SettingData", nil, nil, nil)
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS SettingData" +
                "(setting_id INTEGER PRIMARY KEY, notification INTEGER, default_view INTEGER, default_sort INTEGER, theme INTEGER, avaliable_days INTEGER, start_time INTEGER, end_time INTEGER, last_update INTEGER)", nil, nil, nil)
            
            //Create a default setting for guest login
            sqlite3_exec(dbpointer, "INSERT INTO SettingData (setting_id, notification, default_view, default_sort, theme, avaliable_days, start_time, end_time , last_update) " + "VALUES(0, 1, 0, 0, 0, 127, 8, 24, 0)", nil, nil, nil)
            
            sqlite3_close(dbpointer)
            print(dbPath)
        }
        else {
            print("fail to open database")
        }
        
		// Override point for customization after application launch.
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = .white
        navigationBarAppearace.isTranslucent = false
        //navigationBarAppearace.barTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        navigationBarAppearace.titleTextAttributes =  [ NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedStringKey.foregroundColor : UIColor.white ]
        
        UIBarButtonItem.appearance().setTitleTextAttributes( [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)], for: .normal)
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        let firebaseRef = Database.database().reference()
        firebaseRef.child(".info/connected").observe(.value, with: {(data) in
            if(data.value as! Int32 != 0)
            {
                syncDatabase(userId: TaskManager.sharedTaskManager.getUser().getUserID(), completion: { (flag) in
                    if(flag){
                        print("saving data when enter background")}
                    else{
                        print("unabe to save data when enter background")
                    }
                })
            }
           
        })
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // sync
        syncDatabase(userId: TaskManager.sharedTaskManager.getUser().getUserID(), completion: { (flag) in
            if(flag){
                print("saving data when terminating")}
            else{
                print("unabe to save data when terminating")
            }
        })
        
	}


}

