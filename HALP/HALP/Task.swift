//
//  Task.swift
//  HALP
//
//  Created by Qinlong on 5/5/18.
//	Edited by Qihao on 5/10/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation


enum Category: Double {
    case Study_Work = 1.0
    case Entertainment = 0.25
    case Chore = 0.5
    case Relationship = 0.75
}

enum Weight: Double {
    case Category = 0.3
    case Time = 0.7
}

// TODO: Add more initializer if necessary.
// TODO: Add a comparion function that returns a Bool. True if task1.priority <= task2.priority.
// TODO: Update getter so it returns id as well.
class Task {
	// The following properties all come from user input.
	private var title: String
	private var taskDescription: String
	private var category: Category
	// Unix Epoch timestamp. Milliseconds part discarded.
	private var alarm: Int32
	private var deadline: Int32
	private var softDeadline: Int32
	private var schedule: Int32				// A fixed start time.
	private var duration: Int32
	
	// Internal properties, not from user input.
	private var taskPriority: Double		// System scheduled start time.
	private var scheduled_start: Int32		// Unix epoch timestamp.
    private var notification: Bool          // Whether the notification is on for this task
	private let taskID: Int64				// ID
    private let userID: Int64               // Associated user
	
    
    // Empty initializer
    init() {
        self.title = ""
        self.taskDescription = ""
        self.taskPriority = 0
        self.alarm = 0
        self.category = Category.Study_Work
        self.deadline = 0
        self.softDeadline = 0
        self.schedule = 0
        self.duration = 0
        self.scheduled_start = 0
        self.notification = false
        self.taskID = 0
        self.userID = 0
    }
    
	// Initializer based on property stored in dictioanry.
	// Everything optional. Pass emtpy dictionary if necessary.
	init(StringType s: Dictionary<String,String>, Category c: Category = Category.Study_Work,
         TimestampType t: Dictionary<String,Int32>, Priority p: Double = 0, Notification n: Bool = false, TaskID tid: Int64 = 0, UserID uid: Int64) {
		self.title = s["title"]!
		self.taskDescription = s["taskDescription"]!
		self.category = c
		self.alarm = t["alarm"]!
		self.deadline = t["deadline"]!
		self.softDeadline = t["softDeadline"]!
		self.schedule = t["schedule"]!
		self.duration = t["duration"]!
		self.taskPriority = p
		self.scheduled_start = t["sheduled_start"]!
        self.notification = n
		self.taskID = (tid == 0) ? IDGenerator.generateID(name: title, type: IDType.task) : tid
        self.userID = uid
	}
	
	// Intialize based on property provided by caller.
	// All optional based on usage. Except userid, task should not exist without a user.
	// init() initialize everything to default value.
	init(Title title: String = "", Description taskD: String = "", Category category: Category = Category.Study_Work,
		 Alarm alarm: Int32 = 0, Deadline deadline: Int32 = 0, SoftDeadline softDeadline: Int32 = 0,
		 Schedule schedule: Int32 = 0, Duration duration: Int32 = 0, Priority taskP: Double = 0,
		 Schedule_start scheduled_start: Int32 = 0, Notification notification: Bool = false, TaskID tid: Int64 = 0, UserID uid: Int64) {
		self.title = title
		self.taskDescription = taskD
		self.taskPriority = taskP
		self.alarm = alarm
		self.category = category
		self.deadline = deadline
		self.softDeadline = softDeadline
		self.schedule = schedule
		self.duration = (schedule == 0 || deadline == 0) ? duration : (deadline - schedule)
		self.scheduled_start = (schedule == 0) ? scheduled_start : schedule
		self.notification = notification
		self.taskID = (tid == 0) ? IDGenerator.generateID(name: title, type: .task) : tid
		self.userID = uid
	}
    
    // Copy initializer
    init(_ origin: Task) {
        self.title = origin.getTitle()
        self.taskDescription = origin.getDescription()
        self.taskPriority = origin.getPriority()
        self.alarm = origin.getAlarm()
        self.category = origin.getCategory()
        self.deadline = origin.getDeadline()
        self.softDeadline = origin.getSoftDeadline()
        self.schedule = origin.getSchedule()
        self.duration = origin.getDuration()
        self.scheduled_start = origin.getScheduleStart()
        self.notification = origin.getNotification()
        self.taskID = origin.getTaskId()
        self.userID = origin.getUserId()
    }
	
	// Alternative Initalier.
	// Create a new Task object by primary key and foreign key.
	// Load from database.
	convenience init(_: Bool, TaskID tid: Int64, UserID uid: Int64) throws {
		let DAO = TaskDAO(UserID: uid)
		let dict: Dictionary<String, Any>
		dict = try DAO.fetchTaskInfoFromLocalDB(taskId: tid)
		self.init(dict)
	}
	
	// Alternative Initializer
	init(_ dict: Dictionary<String, Any>) {
		self.title = dict["task_title"] as! String
		self.taskDescription = dict["task_desc"] as! String
		self.category = Category(rawValue: (dict["category"] as! Double))!
		self.alarm = dict["alarm"] as! Int32
		self.deadline = dict["deadline"] as! Int32
		self.softDeadline = dict["soft_deadline"]! as! Int32
		self.schedule = dict["schedule"] as! Int32
		self.duration = dict["duration"] as! Int32
		self.taskPriority = dict["task_priority"] as! Double
		self.scheduled_start = dict["scheduled_start"] as! Int32
		self.notification = (dict["notification"] as! Int32) == 1 ? true : false
		self.taskID = dict["task_id"] as! Int64
		self.userID = dict["user_id"] as! Int64
	}

	// Getter.
	// Return all fields in one dictioanry
	func propertyGetter()->(Dictionary<String, Any>){
		let dict: [String:Any] = ["title":self.title, "taskDescription":self.taskDescription,
								  "category":self.category, "taskPriority":self.taskPriority,
								  "alarm":self.alarm, "deadline":self.softDeadline,
								  "softDeadline":self.softDeadline,"schedule":self.schedule,
								  "duration":self.duration, "scheduled_start":self.scheduled_start,
								  "taskID":self.taskID, "userID":self.userID]
		return dict
	}
	
	// Set fields using passing in dictionary.
	func propertySetter(_ dict:Dictionary<String,Any>) throws {
		for (key,value) in dict {
			switch key {
			case "title":
				self.title = value as! String
			case "taskDescription":
				self.taskDescription = value as! String
			case "taskPriority":
				self.taskPriority = value as! Double
			case "alarm":
				self.alarm = value as! Int32
			case "deadline":
				self.deadline = value as! Int32
			case "schedule":
				self.schedule = value as! Int32
			case "duration":
				self.duration = value as! Int32
			case "category":
				self.category = value as! Category
			case "softDeadline":
				self.softDeadline = value as! Int32
			case "scheduled_start":
				self.scheduled_start = value as! Int32
			default:
				throw RuntimeError.InternalError("Unexpected key in dictionary detected!")
			}
		}
	}
	
	// Fixed task has a priority of 2.
	// Past task has a priority of 3.
	// Regular task has a priority in (0,1).
	func calculatePriority() {
		// Filter fixed tasks.
		if self.schedule != 0 {
			self.taskPriority = 2
			return
		}
		// Get current time.
		let current = Int32(Date().timeIntervalSince1970)
		// Filter past due tasks.
		if current > self.deadline {
			self.taskPriority = 3
			return
		}
		// Calculate priority.
		// p = summation on i (weight_i * standarized_value_i)
		let timeRemaining = self.deadline - current
		let standarized_timeRemaining = Double(self.duration) / Double(timeRemaining)
		self.taskPriority = Weight.Category.rawValue * self.category.rawValue +
							Weight.Time.rawValue * standarized_timeRemaining
	}
  
    //Getters
    func getTaskId() -> Int64 {
        return self.taskID
    }
    
    func getUserId() -> Int64 {
        return self.userID
    }
    
    func getTitle() -> String{
        return self.title
    }
    
    func getDescription() -> String {
        return self.taskDescription
    }
    
    func getCategory() -> Category {
        return self.category
    }
    
    func getAlarm() -> Int32 {
        return self.alarm
    }
    
    func getDeadline() -> Int32 {
        return self.deadline
    }
    
    func getSoftDeadline() -> Int32 {
        return self.softDeadline
    }
    
    func getSchedule() -> Int32 {
        return self.schedule
    }
    
    func getDuration() -> Int32 {
        return self.duration
    }
    
    func getPriority() -> Double {
        return self.taskPriority
    }
    
    func getScheduleStart() -> Int32 {
        return self.scheduled_start
    }
	
    func getNotification() -> Bool {
        return self.notification
    }
    
    // Setters
    func setTitle(_ newTitle: String) {
        self.title = newTitle
    }
    
    func setDescription(_ newDesc: String) {
        self.taskDescription = newDesc
    }
    func setCategory(_ newCategory: Category) {
        self.category = newCategory
    }
    
    func setAlarm(_ newAlarm: Int32) {
        self.alarm = newAlarm
    }
    
    func setDeadline(_ newDeadline: Int32) {
        self.deadline = newDeadline
    }
    
    func setSoftDeadline(_ newSoftDeadline: Int32) {
        self.softDeadline = newSoftDeadline
    }
    
    func setSchedule(_ newSchedule: Int32) {
        self.schedule = newSchedule
    }
    
    func setDuration(_ newDuration: Int32) {
        self.duration = newDuration
    }
    
    func setPriority(_ newPriority: Double) {
        self.taskPriority = newPriority
    }
    
    func setScheduleStart(_ newScheduleStart: Int32) {
        self.scheduled_start = newScheduleStart
    }
    
    func toggleNotification() {
        self.notification = !self.notification
    }
    
    
	// Comparison function overloads operator >
	static func > (left: Task, right: Task) -> (Bool) {
		if left.getPriority() == right.getPriority() {
			if left.getScheduleStart() == right.getScheduleStart() {
				return left.getTaskId() < right.getTaskId()
			}
			return left << right
		}
		return left.getPriority() > right.getPriority()
	}
	
	static func < (left: Task, right: Task) -> (Bool) {
		if left.getPriority() == right.getPriority() {
			if left.getScheduleStart() == right.getScheduleStart() {
				return left.getTaskId() < right.getTaskId()
			}
			return left >> right
		}
		return left.getPriority() < right.getPriority()
	}
	
	static func >> (left: Task, right: Task) -> (Bool) {
		if left.getScheduleStart() == right.getScheduleStart() {
			return left < right
		}
		return left.getScheduleStart() > right.getScheduleStart()
	}
	
	static func << (left: Task, right: Task) -> (Bool) {
		if left.getScheduleStart() == right.getScheduleStart() {
			return left > right
		}
		return left.getScheduleStart() < right.getScheduleStart()
	}
}
