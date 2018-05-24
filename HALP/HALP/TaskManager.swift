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
	
	private var userInfo: UserData?
	private var setting: Setting?
	private var tasks: [Task] = []
	private var theme: ColorTheme = ColorTheme.regular
	// The current viewController when calling any function in TaskManager that needs to handle
	// UI stuff.
	private var viewController: UIViewController? = nil
	// A collection of alerts. Working as a queue.
	private var alerts: [UIAlertController] = []
	// A collection of past tasks. Working as a queue so matches alerts.
	private var pastTasks: [Task] = []
	private var timespan: (Int32, Int32) = (0,0)
	
	// Initializer
	private init () {
		self.clear()
	}
	
	// Setup the taskManager
	func setUp(new user: UserData, setting: Setting, caller vc: UIViewController? = nil) {
		self.userInfo = user
		self.setting = setting
		self.viewController = vc
		switch self.setting?.getTheme() {
		case 1:
			self.theme = ColorTheme.dark
		default:
			self.theme = ColorTheme.regular
		}
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
        let userDAO = UserDAO();
        userDAO.saveUserInfoToLocalDB()
	}
	
	// Update user setting
	func updateSetting(new setting: Setting) {
		self.setting = setting
		// TODO: After user setting is changed, use SettingDAO to store data.
	}
	
	// Add Task
	func addTask(_ form: TaskForm) {
		let newTask = Task(form as Task)
		newTask.calculatePriority()
		print("Adding new task with title: ", newTask.getTitle())
		print("With deadline: ", Date(timeIntervalSince1970: TimeInterval(newTask.getDeadline())).description(with: .current))
		/*
		if newTask < tasks.last! {
			// TODO: save new task to db
			// TODO: also filter fixed tasks too late in the future.
			print("Proceed to save added task!")
			return
		}
		let oldTask = tasks.popLast()
		// TODO: save old task to db
		print("Proceed to update old task with lowest priority!")
		*/
		tasks.append(newTask)
		// Save task to DB
		let DAO = TaskDAO(newTask)
		if !DAO.saveTaskInfoToLocalDB() {
			print("Saving failed!")
		}
		self.refresh()
		self.sortTasks(by: .priority)
		self.schedule()
        let sortType = self.setting!.getDefaultsort();
        self.sortTasks(by: sortType);
	}

    
    
     func scheduleHelper(taskFixed:[DateInterval]) -> Array<DateInterval> {
     var taskFloat = [DateInterval]()
     let calendar = Calendar.current
     var startComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: taskFixed[0].start)
     startComponents.hour = 8
     startComponents.minute = 0
     startComponents.second = 0
     var endComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: taskFixed[0].start)
     endComponents.hour = 23
     endComponents.minute = 59
     endComponents.second = 59
     var i = 0
     var freeTime = DateInterval()
     //make a copy of the array to sort
     var sortedArray = taskFixed
     //sort the array by DateInterval start time.
     sortedArray = sortedArray.sorted(by: { (d1: DateInterval, d2: DateInterval) -> Bool in
     return d1.start < d2.start
     })
     //if you have free time from 8am to your first task
     if sortedArray[0].start > calendar.date(from: startComponents)! {
     freeTime = DateInterval(start: calendar.date(from: startComponents)!, end: sortedArray[0].start)
     taskFloat.append(freeTime)
     }
     //else your first task is at 8am
     else {
     for entry in sortedArray {
     //check if this is your last task
     if i == sortedArray.count - 1 {
     //if it is, then after it ends, you are free until 11:59PM of today
     freeTime = DateInterval(start: sortedArray[i].end, end: calendar.date(from: endComponents)!)
     taskFloat.append(freeTime)
     break
     }
     //Your free time is defined by the time in between the tasks
     freeTime = DateInterval(start: sortedArray[i].end, end: sortedArray[i+1].start)
     taskFloat.append(freeTime)
     i += 1
     }
     }
     return taskFloat
     }
 
    func scheduleKeyGetter(item:Task) -> Date? {
        var date = Date(timeIntervalSince1970: (Double)(item.getSchedule()));
        var component:DateComponents = DateComponents();
        component.year = Calendar.current.component(Calendar.Component.year, from: date);
        component.month = Calendar.current.component(Calendar.Component.month,from:date);
        component.day = Calendar.current.component(Calendar.Component.day,from:date);
        component.hour = 8;
        component.minute = 0;
        component.second = 0;
        return Calendar.current.date(from: component);
    }
	// Schedule all tasks
	func schedule() {
        var taskFloat = [DateInterval]();
        var slots = [Date:[DateInterval]]();
        
        //encapsulate all date
        for item in tasks {
    
            if (item.getPriority() == 2) {
               let key = scheduleKeyGetter(item: item)
                if (slots[key!] == nil) {
                    slots[key!] = [DateInterval]();
                }
                    slots[key!]!.append(DateInterval(start: Date(timeIntervalSince1970: (Double)(item.getSchedule())), duration: (Double)(item.getDuration())));
            }
        }
           // taskDate.append((interval:DateInterval(start: Date(timeIntervalSince1970:(Double)(item.getSchedule())), duration: item.getDuration()) ,priority:item.getPriority()));
        
        for item in tasks {
            if (item.getPriority() < 2) {
                //let itemStart = Date(timeIntervalSince1970: (Double)(item.getSchedule()));
                let itemEnd = Date(timeIntervalSince1970: (Double)(item.getDeadline()));
               let key = scheduleKeyGetter(item:item)
             var found:Bool = false;
                // case if there are some tasks on startTime
                if (slots[key!] != nil) {
                   taskFloat = scheduleHelper(taskFixed:slots[key!]!);
                    if (taskFloat.count != 0) {
                        // can found fit time in the day of start time and the time is before deadline
                        for gap in taskFloat {
                            // that gap fits the requirement and start Time is before deadline
                            if (gap.duration >= (Double)(item.getDuration()) && gap.start < itemEnd) {
                                if (((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60 < item.getDuration() && Calendar.current.isDate(itemEnd, inSameDayAs: key!) == true){
                                     let newDuration = (Int32)(((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60);
                                     let newStartTime = (Int32)(gap.start.timeIntervalSince1970);
                                    try? item.propertySetter(["scheduled_start":newStartTime,"duration":newDuration]);
                                    slots[key!]!.append(DateInterval(start: gap.start, duration: (Double)(newDuration)));
                                    found = true;
                                    break;
                                    
                                }else {
                                // TODO modify case 2 done
                                let newStartTime = (Int32)(gap.start.timeIntervalSince1970);
                                try? item.propertySetter(["scheduled_start":newStartTime]);
                                slots[key!]!.append(DateInterval(start:gap.start, duration:(Double)(item.getDuration())));
                                found = true;
                                break;
                                }
                            }
                        }
                    }
                        // can't found fit time in the day of start time
                        if (found == false) {
                            var keyNew = Date(timeInterval: 24*60*60, since: key!);
                            //continue search the next day till found the first gap that really fits before deadline
                            while (found == false && keyNew <= itemEnd) {
                                // next day has fixed tasks
                                if (slots[keyNew] != nil) {
                                    taskFloat = scheduleHelper(taskFixed: slots[keyNew]!);
                                    // there is gap on the fixe tasks day
                                    if (taskFloat.count != 0) {
                                        for gap in taskFloat {
                                            
                                            // if we the gap time we found fits and before deadline
                                            if (gap.duration >= (Double)(item.getDuration()) && gap.start < itemEnd) {
                                                
                                                if (((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60 < item.getDuration() && Calendar.current.isDate(itemEnd, inSameDayAs: keyNew) == true) {
                                                    let newDuration = (Int32)(((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60);
                                                    let newStartTime = (Int32)(gap.start.timeIntervalSince1970);
                                                    try? item.propertySetter(["scheduled_start":newStartTime,"duration":newDuration]);
                                                    slots[keyNew]!.append(DateInterval(start: gap.start, duration: (Double)(newDuration)));
                                                    found = true;
                                                    break;
                                                }
                                                else {
                                                //CASE 3 TODO MODIFY (done)
                                                let newStartTime = (Int32)(gap.start.timeIntervalSince1970);
                                                try? item.propertySetter(["scheduled_start":newStartTime]);
                                                slots[keyNew]!.append(DateInterval(start: gap.start, duration: (Double)(item.getDuration())));
                                                found = true;
                                                break;
                                                }
                                            }
                                        }
                                    }
                                
                          
                                }
                                //next day doesn't have fixed tasks
                                else {
                                    // MODIFY CASE 4 TODO (done)
                                    if (((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60 < item.getDuration() && Calendar.current.isDate(itemEnd, inSameDayAs: keyNew) == true) {
                                        slots[keyNew] = [DateInterval]();
                                        let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
                                        let newDuration = (Int32)(((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60);
                                        try? item.propertySetter(["duration":newDuration,"scheduled_start":newStartTime])
                                        found = true;
                                       slots[keyNew]!.append(DateInterval(start: taskFloat[0].start, duration: (Double)(item.getDuration())));
                                        break;
                                        
                                    }
                                    else {
                                    slots[keyNew] = [DateInterval]();
                                    taskFloat = scheduleHelper(taskFixed: slots[keyNew]!);
                                    let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
                                    try? item.propertySetter(["scheduled_start":newStartTime]);
                                    found = true;
                                    slots[keyNew]!.append(DateInterval(start: taskFloat[0].start, duration: (Double)(item.getDuration())));
                                        break;
                                    }
                                }
                                if (found == false) {
                                    keyNew = Date(timeInterval: 24*60*60, since: keyNew);
                                }
                            }
                        }
                }
                    //case no task on the startTime
                    //TODO modify this else case 1
                else {
                    // hasn't consider the deadline case yet
                    if (((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60 < item.getDuration() && Calendar.current.isDate(itemEnd, inSameDayAs: key!) == true) {
                        slots[key!] = [DateInterval]();
                        let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
                        let newDuration = (Int32)(((Calendar.current.component(Calendar.Component.hour, from: itemEnd)) - (Int)(self.setting!.getStartTime()))*60*60);
                        try? item.propertySetter(["duration":newDuration,"scheduled_start":newStartTime])
                        found = true;
                        slots[key!]!.append(DateInterval(start: taskFloat[0].start, duration: (Double)(item.getDuration())));
                        break;
                        
                    } else {
                    slots[key!] = [DateInterval]();
                    taskFloat = scheduleHelper(taskFixed: slots[key!]!);
                    let newStartTime = (Int32)(taskFloat[0].start.timeIntervalSince1970);
                    try? item.propertySetter(["scheduled_start":newStartTime])
                    slots[key!]!.append(DateInterval(start:taskFloat[0].start,duration:(Double)(item.getDuration())));
                    break;
                    }
                }
            }
        }
        
		// Follow DUC#15 exactly.
	}
	
	// Refresh priority of all tasks
	func refresh() {
		for task in tasks {
			task.calculatePriority()
		}
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
		self.refresh()
		self.sortTasks(by: .priority)
		self.schedule()
		self.sortTasks(by: .time)
	}

	
	// Remove task by taskID
	func removeTask(taskID:Int64) {
		var i = 0
        let id = taskID;
		//Traverse array of task to find the Task with desired ID
		for entry in tasks {
			//if the task in question has been found
			if entry.getTaskId() == taskID {
				//delete the task
				tasks.remove(at: i)
				//since the ID should be unique, we can break
				break
			}
			i += 1
		}
        //TODO: update Database
        let removeDAO = TaskDAO();
        //test this part in particular
        removeDAO.deleteTaskFromLocalDB(taskId: id);
        
        self.refresh();
        self.sortTasks(by: .priority);
        self.schedule();
        let sortType = self.setting!.getDefaultsort();
        self.sortTasks(by: sortType);

        
	}

	
	// Sort tasks by priority
	func sortTasks(by t: SortingType) {
		//TODO: write tests. I wrote this based on memory.
		tasks.quickSort(0, tasks.count-1, by: t)
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
	
	// Calculate next avaible timespan.
	func calculateTimeSpan() {
		// First determine day.
		let days = Int(self.setting!.getAvailableDays())
		// Determine what day is today.
		let calendar = Calendar.current
		let current = (self.timespan.0 == 0) ? Date() : Date(timeIntervalSince1970: TimeInterval(timespan.0 + 24*60*60))
		var startOfDay = calendar.startOfDay(for: current)
		var dayInWeek = calendar.component(.weekday, from: current)
		var mask = 0b1 << (dayInWeek - 1)
		// Retrieve the first available day
		while ((days & mask) >> (dayInWeek - 1)) != 1 {
			// go to next day
			startOfDay += 24*60*60
			// shift mask left in a cycle
			mask = (mask == 0b1000000) ? 0b1 : mask << 1
			dayInWeek = (dayInWeek == 7) ? 1 : dayInWeek + 1
		}
		// start = 12a.m. of first available day + the start hour converted into seconds
		let startTime = Int32(startOfDay.timeIntervalSince1970) + self.setting!.getStartTime() * 60 * 60
		let endTime = Int32(startOfDay.timeIntervalSince1970) + self.setting!.getEndTime() * 60 * 60
		self.timespan = (startTime, endTime)
	}
	
	// Getters
	func getUser() -> UserData {
		return self.userInfo!
	}
	
	func getSetting() -> Setting {
		return self.setting!
	}
	
	func getTasks() -> [Task] {
		return self.tasks
	}
	
	func getTheme() -> ColorTheme {
		return self.theme
	}
	
	func getTimespan() -> (Int32, Int32) {
		return self.timespan
	}
}
