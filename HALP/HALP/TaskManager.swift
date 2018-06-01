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
        switch self.setting!.getTheme() {
        case .dark:
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
        let userDAO = UserDAO()
        _ = userDAO.saveUserInfoToLocalDB()
    }
    
    // Update user setting
    func updateSetting(setting: Setting) {
        self.setting = setting
        let newSetting = SettingDAO(self.setting!)
        _ = newSetting.updateSettingInLocalDB(settingId: newSetting.getSettingID(), notification: newSetting.isNotificationOn(),
                                       defaultView: newSetting.getDefaultView(), defaultSort: newSetting.getDefaultSort(),
                                       theme: newSetting.getTheme(), availableDays: newSetting.getAvailableDays(),
                                       startTime: newSetting.getStartTime(), endTime: newSetting.getEndTime())
        switch self.setting!.getTheme() {
        case .dark:
            self.theme = ColorTheme.dark
        default:
            self.theme = ColorTheme.regular
        }
        
		
		let navigationBarAppearace = UINavigationBar.appearance()
		navigationBarAppearace.barTintColor = self.getTheme().background
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
        let sortType = self.setting!.getDefaultSort();
        self.sortTasks(by: sortType);
    }
    
    // Refresh priority of all tasks
    func refresh() {
        for task in tasks {
            task.calculatePriority()
        }
    }
    
    // Load tasks from disk
    func createCompletionAlert(_ task: Task) {
        // TaskManager shall proceed to ask the user if they has completed the task.
        let completionAlert = UIAlertController(title: task.getTitle(), message: "Have you completed this task?", preferredStyle: .alert)
        completionAlert.addAction(UIAlertAction(title: "Yes!", style: .cancel, handler: promptNextAlert))
        completionAlert.addAction(UIAlertAction(title: "No!", style: .destructive, handler: promptReschedule))
        alerts.append(completionAlert)
    }
    
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
            // Set a current time.
            let current = Int32(Date().timeIntervalSince1970)
            // The loaded task has passed its scheduled end time.
            if loadedTask.getScheduleStart()+loadedTask.getDuration() < current && loadedTask.getScheduleStart() != 0 && self.viewController != nil {
                pastTasks.append(loadedTask)
                createCompletionAlert(loadedTask)
                continue
            }
            tasks.append(loadedTask)
        }
        self.refresh()
        self.sortTasks(by: .priority)
        self.schedule()
        if self.getSetting().getDefaultSort() == .time {
            self.sortTasks(by: .time)
        } else {
            self.sortTasks(by: .priority)
        }
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
        _ = removeDAO.deleteTaskFromLocalDB(taskId: id);
        self.refresh();
        self.sortTasks(by: .priority);
        self.schedule();
        let sortType = self.setting!.getDefaultSort();
        self.sortTasks(by: sortType);
    }
    
    
    // Update task
    func updateTask(form: TaskForm) {
        //TODO
        let taskDAO = TaskDAO()
        print(form.getTaskId())
        _ = taskDAO.updateTaskInfoInLocalDB(taskId: form.getTaskId(), taskTitle: form.getTitle(),
                                        taskDesc: form.getDescription(), category: form.getCategory().rawValue,
                                        alarm: Int(form.getAlarm()), deadline: Int(form.getDeadline()),
                                        softDeadline: Int(form.getSoftDeadline()), schedule: Int(form.getSchedule()),
                                        duration: Int(form.getDuration()), taskPriority: form.getPriority(),
                                        scheduleStart: Int(form.getScheduleStart()), notification: form.getNotification())
    }
    
    // Sort tasks by priority or time
    func sortTasks(by t: SortingType) {
        //TODO: write tests. I wrote this based on memory.
        tasks.quickSort(0, tasks.count-1, by: t)
    }
    
    // Refresh TaskManager. In particular, check if any past task is in current collection.
    func refreshTaskManager() {
        var indexs = [Int]()
        for (index,task) in self.tasks.enumerated() {
            print(index)
            if task.getScheduleStart() != 0 && task.getScheduleStart() + task.getDuration()    <= Int32(Date().timeIntervalSince1970) {
                indexs.append(index)
                pastTasks.append(task)
                self.createCompletionAlert(task)
            }
        }
        
        indexs = indexs.sorted()
        indexs = indexs.reversed()
        
        for index in indexs {
            print(index)
            self.tasks.remove(at: index)
        }
        
        self.refresh()
        self.sortTasks(by: .priority)
        self.schedule()
        self.sortTasks(by: self.setting!.getDefaultSort())
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
                let removeDAO = TaskDAO()
                _ = removeDAO.deleteTaskFromLocalDB(taskId: self.pastTasks[0].getTaskId())
                self.pastTasks.remove(at: 0)
            })
        } else {
            let removeDAO = TaskDAO()
            _ = removeDAO.deleteTaskFromLocalDB(taskId: self.pastTasks[0].getTaskId())
            self.pastTasks.remove(at: 0)
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
        self.clearTimeSpan()
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
        if startTime > Int32(Date().timeIntervalSince1970) {
            self.timespan = (startTime, endTime)
        } else {
            self.timespan = (Int32(Date().timeIntervalSince1970), endTime)
        }
    }
    
    func clearTimeSpan() {
        self.timespan = (0,0)
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
