//
//  TaskManager.swift
//  HALP
//
//  Created by Qihao Leng on 5/5/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

// This class handles main functionality. Only one instacne of TaskManager should exist in runtime. 
class TaskManager {
	
	// The singleton instance in the app
	static let sharedTaskManager = TaskManager()
	
	var userInfo: UserData?
	var tasks: [Task] = []
	
	// Initializer
	private init () {
	}
	
	// Setup the taskManager
	func setUp(new user: UserData) {
		self.userInfo = user
		self.tasks.removeAll()
		self.loadTasks()
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
		//TODO: quick sort
	}
	
	// Reschedule a task
	func reschedule(_ task: Task) {
		//TODO: remove old task from array, update it, call refresh, add it to array, call sort
	}
}
