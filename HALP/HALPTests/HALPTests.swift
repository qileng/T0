//
//  HALPTests.swift
//  HALPTests
//
//  Created by Qihao Leng on 4/27/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import XCTest
@testable import HALP
import SQLite3

class HALPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		// Initialize local database
		let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		let dbPath = documentsPath + "/appData.sqlite"
		var dbpointer: OpaquePointer? = nil
		
		if sqlite3_open(dbPath, &dbpointer) == SQLITE_OK {
			// UserData table
			sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS UserData" +
				"(user_id INTEGER PRIMARY KEY, user_name TEXT, password TEXT, email TEXT, last_update INTEGER)", nil, nil, nil)
			// Initialize guest account
			sqlite3_exec(dbpointer, "INSERT INTO UserData (user_id, user_name, password, email, last_update) " +
				"VALUES (0, 'GUEST', 'GUEST', 'GUEST@GUEST.com', 0)", nil , nil, nil)
			
			// TaskData table
			sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS TaskData" +
				"(task_id INTEGER PRIMARY KEY, task_title TEXT, task_desc TEXT, " +
				"category REAL, alarm INTEGER, deadline INTEGER, soft_deadline INTEGER, schedule INTEGER, duration INTEGER, " +
				"task_priority REAL, schedule_start INTEGER, notification INTEGER, user_id INTEGER, last_update INTEGER)", nil, nil, nil)
			
			// SettingData table not yet implemented
			sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS SettingData" +
				"(setting_id INTEGER PRIMARY KEY, placeholder TEXT)", nil, nil, nil)
			sqlite3_close(dbpointer)
		}
		else {
			print("fail to open database")
		}
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}
    
    func testa_SaveUserInfoToLocalDB() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		print("Testing UserDAO write.\n")
		let testUser1 = UserData(username: "randomuser", password: "something", email: "gary@gillespie.com")
		let testDAO = UserDAO(testUser1)
        XCTAssertEqual(testDAO.saveUserInfoToLocalDB(), true)
		
    }
	
	func testFetchUserInfoFromLocalDB() {
		print("Testing UserDAO read.\n")
		// test exiting user
		do {
			let testUser2 = try UserData(true, email: "gary@gillespie.com", password: "something")
			print(testUser2.getUsername())
			print(testUser2.getPassword())
			print(testUser2.getUserEmail())
			print(String(testUser2.getUserID(), radix: 16))
		} catch RuntimeError.DBError(let errorMessage){
			print(errorMessage)
		} catch RuntimeError.InternalError(let errorMessage) {
			print(errorMessage)
		} catch {
			print("Unexpected error!")
		}

		// testing non-existing user
		do {
			let testUser3 = try UserData(true, email: "GUEST1@GUEST1.com", password: "GUEST")
			print(testUser3.getUsername())
			print(testUser3.getPassword())
			print(testUser3.getUserEmail())
			print(String(testUser3.getUserID(), radix: 16))
		} catch {
			print("Authentification failed!")
		}
	}
    
    func testValidateUserEmail () {
        print("Testing validateUserEmail.\n")
        
        //Add a user to database
        let testUser = UserData(username: "test", password: "test", email: "test@test.com")
        let testDAO = UserDAO(testUser)
        testDAO.saveUserInfoToLocalDB()
        
        //Testing duplicate email
        let UserWithDuplicateEmail = UserData(username: "randomuser", password: "12345", email: "test@test.com")
        let DAO = UserDAO(UserWithDuplicateEmail)
        let result = DAO.validateUserEmailOnline(email: DAO.getUserEmail(), onlineDB: false)
        XCTAssertEqual(false, result)
        
        //Testing valid email
        let validUser = UserData(username: "randomuser", password: "12345", email: "test@est.com")
        let DAO1 = UserDAO(validUser)
        let result1 = DAO.validateUserEmailOnline(email: DAO1.getUserEmail(), onlineDB: false)
        XCTAssertEqual(true, result1)
    }
    
    func testa_SaveTaskInfoToLocalDB() {
        
        print("Testing saveTaskInfoToLocalDB.\n")
        let task1 = Task(Title: "Test1", Description: "blahblah", Category: Category.Relationship, Alarm: 852, Deadline: 13462, SoftDeadline: 134, Schedule: 93, Duration: 123, Priority: 33.33, Schedule_start: 111, Notification: true, TaskID: 0000, UserID: 123456)
        let task2 = Task(Title: "Test2", Description: "blahblah", Category: Category.Relationship, Alarm: 00, Deadline: 1234, SoftDeadline: 134, Schedule: 93, Duration: 123, Priority: 0.00, Schedule_start: 111, Notification: false, TaskID: 7777, UserID: 123456)
		let task3 = Task(Title: "Test3", Description: "blahblah", Category: Category.Relationship, Alarm: 22, Deadline: 13462, SoftDeadline: 134, Schedule: 93, Duration: 123, Priority: 0.00, Schedule_start: 111, TaskID: 1234, UserID: 123456)
		let task4 = Task(Title: "Test4", Description: "blahblah", Category: Category.Relationship, Alarm: 8512, Deadline: 0, SoftDeadline: 134, Schedule: 93, Duration: 123, Priority: 33.33, Schedule_start: 111, TaskID: 4321, UserID: 7890)
		let task5 = Task(Title: "Test5", Description: "blahblah", Category: Category.Relationship, Alarm: 8522, Deadline: 4, SoftDeadline: 134, Schedule: 93, Duration: 123, Priority: 33.33, Schedule_start: 111, TaskID: 2048, UserID: 78122)
         
         let taskDAO1 = TaskDAO(task1)
         let taskDAO2 = TaskDAO(task2)
         let taskDAO3 = TaskDAO(task3)
         let taskDAO4 = TaskDAO(task4)
         let taskDAO5 = TaskDAO(task5)
        
        //Duplicate insertion not allowed
        XCTAssertEqual(taskDAO1.saveTaskInfoToLocalDB(), true)
        XCTAssertEqual(taskDAO1.saveTaskInfoToLocalDB(), false)
        
        // Have to delete all the tasks if you want to re-run this test
        // or else the methond will try to insert duplicat tasks which will fail
        XCTAssertEqual(taskDAO2.saveTaskInfoToLocalDB(), true)
        XCTAssertEqual(taskDAO3.saveTaskInfoToLocalDB(), true)
        XCTAssertEqual(taskDAO4.saveTaskInfoToLocalDB(), true)
        XCTAssertEqual(taskDAO5.saveTaskInfoToLocalDB(), true)
    }
    
    func testFetchTaskInfoFromLocalDB() {
        print("Testing fetchTaskInfoFromLocalDB.\n")
        
        let testDAO = TaskDAO()
        do {
           let dict = try testDAO.fetchTaskInfoFromLocalDB(taskId: 1234)
            for (key,values) in dict {
				print(key + " : " ,values)
                print("\n")
            }
        }
        catch {
            print("error")
        }
    }
    
    func testFetchTaskIdListFromLocalDB() {
        
        print("Testing fetchTaskIdListFromLocalDB.\n")
        let testDAO = TaskDAO()
        do {
            let array = try testDAO.fetchTaskIdListFromLocalDB(userId: 123456)
            for values in array {
                print(values)
                print("\n")
            }
        }
        catch {
            print("error")
        }
    }
    
    func testUpdateTaskInfoInLocalDB() {
        
        print("Testing updateTaskInfoInLocalDB.\n")
        let testDAO = TaskDAO()
        
        //Testing update all entries
        XCTAssertEqual(testDAO.updateTaskInfoInLocalDB(taskId: 0000, taskTitle: "update1", taskDesc: "success1", category: 1, alarm: 0, deadline: 1, softDeadline: 2, schedule: 5, duration: 123, taskPriority: 0.5, scheduleStart: 9, notification: false), true)
        
        //Testing not updating any thing
        XCTAssertEqual(testDAO.updateTaskInfoInLocalDB(taskId: 1234), true)
        
        //Testing updating some entries
        XCTAssertEqual(testDAO.updateTaskInfoInLocalDB(taskId: 2048, taskTitle: "update2", taskDesc: "success2", category: 0.25, duration: 314159, notification: true), true)
        XCTAssertEqual(testDAO.updateTaskInfoInLocalDB(taskId: 4321, taskTitle: "update3", category: 0.25, duration: 314159, notification: true), true)
        XCTAssertEqual(testDAO.updateTaskInfoInLocalDB(taskId: 7777, taskDesc: "success3", category: 0.25, alarm: 2018, duration: 314159, notification: true), true)
    

    }
    
    func testz_DeleteTaskFromLocalDB() {
        
        print("Testing deleteTaskFromLocalDB.\n")
        
        let testDAO = TaskDAO()
        XCTAssertEqual(testDAO.deleteTaskFromLocalDB(taskId: 0000), true)
        XCTAssertEqual(testDAO.deleteTaskFromLocalDB(taskId: 7777), true)
        XCTAssertEqual(testDAO.deleteTaskFromLocalDB(taskId: 1234), true)
        XCTAssertEqual(testDAO.deleteTaskFromLocalDB(taskId: 4321), true)
        XCTAssertEqual(testDAO.deleteTaskFromLocalDB(taskId: 2048), true)
    }
	
	func testTaskComparison() {
		print("Testing Task Comparison.")
		
		let task1 = Task(Priority: 3, UserID: 1)
		let task2 = Task(Priority: 2, UserID: 2)
		let task3 = Task(Priority: 0.5, UserID: 3)
		
		XCTAssertEqual(task1 < task2, false)
		XCTAssertEqual(task2 < task3, false)
		XCTAssertEqual(task3 < task1, true)
	}
	
	func testTaskManagerLoad() {
		print("Testing TaskManager Load.")
		
		let testUser: UserData
		do {
			testUser = try UserData(true, email: "GUEST@GUEST.com", password: "GUEST")
		} catch RuntimeError.DBError(let errorMessage) {
			print(errorMessage)
			return
		} catch {
			print("Unexpected Error")
			return
		}
		
		var tasks: [Task] = []
		tasks.append(Task(Title: "Task1", Priority: 3, UserID: 0))
		tasks.append(Task(Title: "Task2", Schedule: 120, Priority: 2, UserID: 0))
		tasks.append(Task(Title: "Task3", Schedule: 130, Priority: 2, UserID: 0))
		tasks.append(Task(Title: "Task4", Priority: 0.5, UserID: 0))
		tasks.append(Task(Title: "Task5", Priority: 0.24, UserID: 0))
		tasks.append(Task(Title: "Task6", Priority: 0.34, UserID: 0))
		tasks.append(Task(Title: "Task7", Priority: 0.32, UserID: 0))
		tasks.append(Task(Title: "Task8", Priority: 0.44, UserID: 0))
		
		for task in tasks {
			let DAO = TaskDAO(task)
			XCTAssertEqual(DAO.saveTaskInfoToLocalDB(), true)
		}
		print("Total of ", TaskManager.sharedTaskManager.tasks.count, " tasks!")

		TaskManager.sharedTaskManager.setUp(new: testUser, setting: Setting())
		print("Total of ", TaskManager.sharedTaskManager.tasks.count, " tasks!")
		
		for task in TaskManager.sharedTaskManager.tasks {
			print(task.getTitle())
			print(task.getTaskId())
		}
	}
	
	func testTaskManagerSort() {
		print("Testing TaskManager Sort.")
		TaskManager.sharedTaskManager.sortTasks()
		for task in TaskManager.sharedTaskManager.tasks {
			print(task.getTitle())
			print(task.getPriority())
		}
	}
    
    
	/*
	func testSettingDAO() {
		print("Testing SettingDAO write.\n")
		let testUser = UserData(true)
		let testSettingDAO = SettingDAO(user: testUser.getUserID(), notification: false, suggestion: false, fontSize: 15, defaultView: .list)
		testSettingDAO.writeToDisk()
		print("Testing SettingDAO read.\n")
		let testSetting = Setting(true)
		print(testSetting.getSettingID())
		print(testSetting.getUserID())
		print(testSetting.isNotificationOn())
		print(testSetting.isSuggestionOn())
		print(testSetting.getFontSize())
		print(testSetting.getDefaultView().rawValue)
	}
*/
	
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	override class func tearDown() {
		super.tearDown()
		let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		let dbPath = documentsPath + "/appData.sqlite"
        var dbpointer: OpaquePointer? = nil
		/*
        sqlite3_open(dbPath, &dbpointer)
        sqlite3_exec(dbpointer, "DROP TABLE UserData", nil, nil, nil)
        sqlite3_exec(dbpointer, "DROP TABLE TaskData", nil, nil, nil)
        sqlite3_exec(dbpointer, "DROP TABLE SettingData", nil, nil, nil)
        sqlite3_close(dbpointer)
		*/
	}
}
