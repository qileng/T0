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
	}
	
	// Setup the taskManager
	func setUp(new user: UserData, setting: Setting) {
		self.userInfo = user
		self.setting = setting
		self.tasks.removeAll()
		self.loadTasks()
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
	func loadTasks() {
		//TODO
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
