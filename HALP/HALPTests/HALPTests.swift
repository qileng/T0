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
		db = "/testData.sqlite"
		// Initialize local database
		let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		let dbPath = documentsPath + db
		print(dbPath)
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
    
    func testHelper() {
        var taskFixed:[DateInterval] = [DateInterval]();
        
        var component:DateComponents = DateComponents();
        component.year = 2018;
        component.month = 5;
        component.day = 2;
        component.hour = 8;
        component.minute = 0;
        component.second = 0;
        let fixed1 = Calendar.current.date(from: component);
        taskFixed.append(DateInterval(start: fixed1!, duration: 18000));
        
        let fixed2 = Date(timeInterval: 28800, since: fixed1!)
        taskFixed.append(DateInterval(start: fixed2, duration: 7200));
        
        
        
        
        let TaskM = TaskManager.sharedTaskManager;
        var results = TaskM.scheduleHelperE(taskFixed:taskFixed);
        
        for (index,item) in results.enumerated() {
            print("gap start \(index)" + " day is  \(Calendar.current.component(Calendar.Component.day, from: item.start)) \n" +
            " hour is \(Calendar.current.component(Calendar.Component.hour, from: item.start) )" +
            " minute is \(Calendar.current.component(Calendar.Component.minute, from: item.start))" +
            " second is \(Calendar.current.component(Calendar.Component.second, from: item.start))" +
                "gap end \(index)" + " day is  \(Calendar.current.component(Calendar.Component.day, from: item.end)) \n" +
                " hour is \(Calendar.current.component(Calendar.Component.hour, from: item.end) )" +
                " minute is \(Calendar.current.component(Calendar.Component.minute, from: item.end))" +
                " second is \(Calendar.current.component(Calendar.Component.second, from: item.end))")
            
        }
        
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
		let current = Int32(Date().timeIntervalSince1970)
		tasks.append(Task(Title: "Task1", Priority: 3, Schedule_start: current + 60,UserID: 0))
		tasks.append(Task(Title: "Task2", Schedule: current + 120, Priority: 2, UserID: 0))
		tasks.append(Task(Title: "Task3", Schedule: current + 180, Priority: 2, UserID: 0))
		tasks.append(Task(Title: "Task4", Priority: 0.5, Schedule_start: current + 240, UserID: 0))
		tasks.append(Task(Title: "Task5", Priority: 0.24, Schedule_start: current + 300, UserID: 0))
		tasks.append(Task(Title: "Task6", Priority: 0.34, Schedule_start: current + 360, UserID: 0))
		tasks.append(Task(Title: "Task7", Priority: 0.32, Schedule_start: current + 480, UserID: 0))
		tasks.append(Task(Title: "Task8", Priority: 0.44, Schedule_start: current + 420, UserID: 0))
		
		for task in tasks {
			let DAO = TaskDAO(task)
			XCTAssertEqual(DAO.saveTaskInfoToLocalDB(), true)
		}
		print("Total of ", TaskManager.sharedTaskManager.getTasks().count, " tasks!")

		TaskManager.sharedTaskManager.setUp(new: testUser, setting: Setting())
		print("Total of ", TaskManager.sharedTaskManager.getTasks().count, " tasks!")
		
		for task in TaskManager.sharedTaskManager.getTasks() {
			print(task.getTitle())
			print(task.getTaskId())
		}
	}
	
	func testTaskManagerSort() {
		print("Testing TaskManager Sort by pririty.")
		TaskManager.sharedTaskManager.sortTasks(by: .priority)
		for task in TaskManager.sharedTaskManager.getTasks() {
			print(task.getTitle())
			print(task.getPriority())
		}
		print("Tesing TaskManager Sort by time.")
		TaskManager.sharedTaskManager.sortTasks(by: .time)
		for task in TaskManager.sharedTaskManager.getTasks() {
			print(task.getTitle())
			print(Date(timeIntervalSince1970: TimeInterval(task.getScheduleStart())).description(with: .current))
		}
	}
	
	func testRemoveTask() {
		print("Testing Remove Task!")
		let testTask = TaskForm(TaskID: 12345, UserID: 12345)
		TaskManager.sharedTaskManager.addTask(testTask)
		let DAO = TaskDAO()
		var	result: [Int64]
		do {
			result = try DAO.fetchTaskIdListFromLocalDB(userId: 12345)
			XCTAssertEqual(result.contains(12345), true)
		} catch RuntimeError.DBError(let errorMessage) {
			print(errorMessage)
		} catch RuntimeError.InternalError(let errorMessage) {
			print(errorMessage)
		} catch {
			print("Unexpected Error!")
		}
		TaskManager.sharedTaskManager.removeTask(taskID: 12345)
		do {
			result = try DAO.fetchTaskIdListFromLocalDB(userId: 12345)
			XCTAssertEqual(result.contains(12345), false)
		} catch RuntimeError.DBError(let errorMessage) {
			print(errorMessage)
		} catch RuntimeError.InternalError(let errorMessage) {
			print(errorMessage)
		} catch {
			print("Unexpected Error!")
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
	
    
    /*
    * Why is there a initializer taking date as argument
    * all date should be stored as time interval since 1970
	func testz_AddTask() {
		let inputTask = TaskForm(Title: "Input task1", Description: "User input task", Category: .Relationship, Alarm: 1800, Deadline: Date(timeIntervalSinceNow: 3600), SoftDeadline: Date(timeIntervalSinceNow: 1800), Schedule: nil, Duration: 3600, UserID: 0)
		let writeDAO = TaskDAO(inputTask)
		XCTAssertEqual(writeDAO.saveTaskInfoToLocalDB(), true)
		
		let readDAO = TaskDAO()
		do {
			let dict = try readDAO.fetchTaskInfoFromLocalDB(taskId: inputTask.getTaskId())
			for (key,values) in dict {
				print(key + " : " ,values)
				print("\n")
			}
		}
		catch {
			print("error")
		}
	}
 */
	
	func testCalculateTimeSpan() {
		print("Testing Calculate time span!")
		let testSetting = Setting(availableDays: Int32(0b0111110), startTime: Int32(18), endTime: Int32(22), user: 0)
		TaskManager.sharedTaskManager.setUp(new: UserData(username: "Test", password: "blah", email: "blah"), setting: testSetting)
		TaskManager.sharedTaskManager.calculateTimeSpan()
		print("First available is ", Date(timeIntervalSince1970: TimeInterval(TaskManager.sharedTaskManager.getTimespan().0)).description(with:.current), " to ", Date(timeIntervalSince1970: TimeInterval(TaskManager.sharedTaskManager.getTimespan().1)).description(with:.current))
		TaskManager.sharedTaskManager.calculateTimeSpan()
		print("Next available is ", Date(timeIntervalSince1970: TimeInterval(TaskManager.sharedTaskManager.getTimespan().0)).description(with:.current), " to ", Date(timeIntervalSince1970: TimeInterval(TaskManager.sharedTaskManager.getTimespan().1)).description(with:.current))
		TaskManager.sharedTaskManager.calculateTimeSpan()
		print("Next available is ", Date(timeIntervalSince1970: TimeInterval(TaskManager.sharedTaskManager.getTimespan().0)).description(with:.current), " to ", Date(timeIntervalSince1970: TimeInterval(TaskManager.sharedTaskManager.getTimespan().1)).description(with:.current))
	}
	
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
	
	override class func tearDown() {
		super.tearDown()
		let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		let dbPath = documentsPath + db
        var dbpointer: OpaquePointer? = nil
        sqlite3_open(dbPath, &dbpointer)
        sqlite3_exec(dbpointer, "DROP TABLE UserData", nil, nil, nil)
        sqlite3_exec(dbpointer, "DROP TABLE TaskData", nil, nil, nil)
        sqlite3_exec(dbpointer, "DROP TABLE SettingData", nil, nil, nil)
        sqlite3_close(dbpointer)
		
	}
}
