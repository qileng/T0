//
//  Task.swift
//  HALP
//
//  Created by Qinlong on 5/5/18.
//	Edited by Qihao on 5/5/18.
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

class Task {
	// Properties. Associated with user input.
	private var title: String
	private var taskDescription: String
	private var category: Category
	// Unix Epoch timestamp. Milliseconds part discarded.
	private var alarm: Int
	private var deadline: Int
	private var softDeadline: Int
	private var schedule: Int				// A fixed start time.
	private var duration: Int
	
	// Internal properties.
	private var taskPriority: Double
	private var scheduled_start: Int		// Unix epoch timestamp.
	private let taskID: Int64				// ID
	
	// Initializer based on property stored in dictioanry.
	// Everything optional. Pass emtpy dictionary if necessary.
	init(StringType s: Dictionary<String,String>, Category c: Category = Category.Study_Work,
		 TimestampType t: Dictionary<String,Int>, Priority p: Double = 0, ID tid: Int64 = 0) {
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
		self.taskID = (tid == 0) ? IDGenerator.generateID(name: title, type: IDType.task) : tid
	}
	
	// Intialize based on property provided by caller.
	// All optional based on usage.
	// init() initialize everything to default value.
	init(Title title: String = "", Description taskD: String = "", Category category: Category,
		 Alarm alarm: Int = 0, Deadline deadline: Int = 0, SoftDeadline softDeadline: Int = 0,
		 Schedule schedule: Int = 0, Duration duration: Int = 0, Priority taskP: Double = 0,
		 Schedule_start scheduled_start: Int = 0, ID tid: Int64 = 0) {
		self.title = title
		self.taskDescription = taskD
		self.taskPriority = taskP
		self.alarm = alarm
		self.category = category
		self.deadline = deadline
		self.softDeadline = softDeadline
		self.schedule = schedule
		self.duration = duration
		self.scheduled_start = scheduled_start
		self.taskID = tid
	}
	
	// Getter.
	// Return all fields in one dictioanry
	func propertyGetter()->(Dictionary<String, Any>){
		let dict: [String:Any] = ["title":self.title, "taskDescription":self.taskDescription,
								  "category":self.category, "taskPriority":self.taskPriority,
								  "alarm":self.alarm, "deadline":self.softDeadline,
								  "softDeadline":self.softDeadline,"schedule":self.schedule,
								  "duration":self.duration, "scheduled_start":self.scheduled_start,
								  "taskID":self.taskID]
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
				self.alarm = value as! Int
			case "deadline":
				self.deadline = value as! Int
			case "schedule":
				self.schedule = value as! Int
			case "duration":
				self.duration = value as! Int
			case "category":
				self.category = value as! Category
			case "softDeadline":
				self.softDeadline = value as! Int
			case "scheduled_start":
				self.scheduled_start = value as! Int
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
		let current = Int(Date().timeIntervalSince1970)
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
}
