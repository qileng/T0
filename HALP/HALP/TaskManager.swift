//
//  TaskManager.swift
//  HALP
//
//  Created by Qihao Leng on 5/5/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit

// This class handles main functionality. Only one instacne of TaskManager should exist in runtime.
// For implementation: follow Design use cases.
class TaskManager {
	
	// The singleton instance in the app
	static let sharedTaskManager = TaskManager()
	
	var userInfo: UserData?
	var setting: Setting?
	var tasks: [Task] = []
	// The current viewController when calling any function in TaskManager that needs to handle
	// UI stuff.
	var viewController: UIViewController? = nil
	// A collection of alerts. Working as a queue.
	var alerts: [UIAlertController] = []
	// A collection of past tasks. Working as a queue so matches alerts.
	var pastTasks: [Task] = []
	
	// Initializer
	private init () {
		self.clear()
	}
	
	// Setup the taskManager
	func setUp(new user: UserData, setting: Setting, caller vc: UIViewController? = nil) {
		self.userInfo = user
		self.setting = setting
		self.viewController = vc
		self.clear()
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
		print("Loading tasks!")
		for taskID in primary_key {
			// load task by primary_key.
			let loadedTask = try Task(true, TaskID: taskID, UserID: foreign_key!)
			print("Loading ", loadedTask.getTitle(), " with ", loadedTask.getScheduleStart())
			// Set a current time.
			let current = Int32(Date().timeIntervalSince1970)
			// The loaded task has passed its scheduled start time.
			if loadedTask.getScheduleStart() < current && loadedTask.getScheduleStart() != 0 && self.viewController != nil {
				pastTasks.append(loadedTask)
				// TaskManager shall proceed to ask the user if they has completed the task.
				let completionAlert = UIAlertController(title: loadedTask.getTitle(), message: "Have you completed this task?", preferredStyle: .alert)
				completionAlert.addAction(UIAlertAction(title: "Yes!", style: .cancel, handler: promptNextAlert))
				completionAlert.addAction(UIAlertAction(title: "No!", style: .destructive, handler: promptReschedule))
				alerts.append(completionAlert)
				continue
			}
			tasks.append(loadedTask)
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
	
	// Callback function used in UIViewController.present(::completion:)
	// First function called in the chain of callbacks.
	func promptNextAlert(_ vc: UIViewController) {
		self.viewController = vc
		if !alerts.isEmpty {
			let alert = alerts[0]
			viewController?.present(alert, animated: true, completion: {()->() in
				self.alerts.remove(at: 0)
			})
		}
	}
	// Callback function used in UIAlertAction(::handler:)
	// Called by action on "Yes" from completionAlert and "No" from rescheduleAlert.
	func promptNextAlert(_: UIAlertAction) {
		if !alerts.isEmpty {
			let alert = alerts[0]
			viewController?.present(alert, animated: true, completion: {()->() in
				self.alerts.remove(at: 0)
				self.pastTasks.remove(at: 0)
			})
		}
	}
	
	// Callaback funtion used in UIAlertAction(::handler:)
	// Called by action on "No" from completionAlert.
	func promptReschedule(_: UIAlertAction) -> () {
		print("proceed to prompt Reschedule!")
		let rescheduleAlert = UIAlertController(title: "", message: "Do you want to reschedule it?", preferredStyle: .alert)
		rescheduleAlert.addAction(UIAlertAction(title: "Yes!", style: .default, handler: reschedule))
		rescheduleAlert.addAction(UIAlertAction(title: "No!", style: .cancel, handler: promptNextAlert))
		viewController?.present(rescheduleAlert, animated: true, completion: nil)
	}
	
	// Callback function used in UIAlertAction(::handler:)
	// Called by action on "Yes" from RescheduleAlert.
	func reschedule(_: UIAlertAction) {
		let task = pastTasks[0]
		// TODO: Just put task in tasks. Leave schedule to another function so that we don't
		// perform a scheduling process for each task.
		print("Rescheduling ", task.getTitle())
		pastTasks.remove(at: 0)
		promptNextAlert(self.viewController!)
	}
	
	// Clear sharedInstance
	func clear() {
		tasks.removeAll()
		alerts.removeAll()
		pastTasks.removeAll()
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
			} while self[i] > p
			repeat {
				j = j - 1
			} while self[j] < p
			
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
