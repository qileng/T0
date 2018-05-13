//
//  TaskManager.swift
//  HALP
//
//  Created by Qihao Leng on 5/5/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

// This class handles main functionality. Only one instacne of TaskManager should exist in runtime.
// For implementation: follow Design use cases.
class TaskManager {
	
	// The singleton instance in the app
	static let sharedTaskManager = TaskManager()
	
	var userInfo: UserData?
	var setting: Setting?
	var tasks: [Task] = []
	
	// Initializer
	private init () {
		tasks.removeAll()
	}
	
	// Setup the taskManager
	func setUp(new user: UserData, setting: Setting) {
		self.userInfo = user
		self.setting = setting
		self.tasks.removeAll()
		do {
			try self.loadTasks()
		} catch RuntimeError.DBError(let errorMessage) {
			print(errorMessage)
		} catch {
			print("Unexpected Error!")
		}
	}
	
	// Update user information
	func updateUser(new user: UserData) {
		self.userInfo = user
		// TODO: After user information is changed, use UserDAO to store data.
	}
	
	// Update user setting
	func updateSetting(new setting: Setting) {
		self.setting = setting
		// TODO: After user setting is changed, use SettingDAO to store data.
	}
	
	// Refresh priority of all tasks
	func refresh() {
		//TODO
	}
	
	// Load tasks from disk
	func loadTasks() throws {
		// Step 1: get user ID.
		let foreign_key = self.userInfo?.getUserID()
		// Step 2: query database with foreign key to get a list of primary key
		let DAO = TaskDAO(UserID: foreign_key!)
		let primary_key = try DAO.fetchTaskIdListFromLocalDB(userId: DAO.getUserId())
		// Step 3: retrieve Tasks
		// For now, just read all.
		// TODO: Maintain a min-heap.
		// TODO: Filter fixed time task which happens not whithin 24 hours.
		// TODO: Filter past due tasks.
		for taskID in primary_key {
			try tasks.append(Task(true, TaskID: taskID, UserID: foreign_key!))
		}
	}
	
	// Remove task
	func removeTask() {
		//TODO
	}
	
	// Add task
	func addTask() {
		//TODO
	}
	
	// Update task
	func updateTask() {
		//TODO
	}
	
	// Sort tasks by priority
	func sortTasks() {
		//TODO: write tests. I wrote this based on memory.
		tasks.quickSort(0, tasks.count-1)
	}
	
	// Reschedule a task
	func reschedule(_ task: Task) {
		//TODO: remove old task from array, update it, call refresh, add it to array, call sort
	}
	
	// Clear sharedInstance
	func clear() {
		tasks.removeAll()
	}
}

// Quick sort extension for [Task]
extension Array where Element: Task {
	mutating func quickSort(_ head: Int, _ tail: Int) {
		if (head >= tail) {
			return
		}
		
		let pivot = self.partition(head, tail)
		self.quickSort(head, pivot)
		self.quickSort(pivot+1, tail)
	}
	
	mutating func partition(_ head: Int, _ tail: Int) -> (Int) {
		let p: Task = self[head]
		var i = head - 1
		var j = tail + 1
		while true {
			repeat {
				i = i + 1
			// Should be strictly less than. But highly unlikely two Tasks will equal.
			} while self[i] <= p
			repeat {
				j = j - 1
			} while !(self[j] <= p)
			
			if i < j {
				let temp = self[i]
				self[i] = self[j]
				self[j] = temp
			} else {
				return j
			}
		}
	}
}
