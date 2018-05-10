//
//  TaskManager.swift
//  HALP
//
//  Created by 张秦龙 on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

/**
 details of functionality should be discussed
 */
import UIKit

class TaskManager {
    
    // The singleton instance in the app
    static let sharedTaskManager = TaskManager();
    
    var task:[TaskCapsule];
    
    init() {
        
    }
    
    init(taskArray:[Task]) {
        for (index,item) in taskArray.enumerated() {
            self.task[index] = TaskCapsule(task: item);
        }
    }
    
    
    /*
     method that add new Tasks
     */
    
    func addTask(Task:Task) {
        
    }
    
    /*
     method that remove tasks
    */
    func removeTask(Task:Task) {
        
    }
    
    
    /*
     update certain task
     */
    func updateTask(task:Task,newValue:Dictionary<String,Any>) {
        
    }
    /*
     method sortTask is called in refresh()
     */
    func refresh() {
        
    }
    
    /*
     sort the task and reorder them in task array to form
     priorityQueue
     */
    func sortTasks() {
        
        
    }
    
    /*
     calculate priority based on certain algorithm using Task
     */
    func priorityCalculate(Task:Task) {
        
    }
    
    /*
     wrote all the updated changed of task to disk
     attention: only handle task in the task array
    */
    func writeToDisk() ->Bool {
        return false;
    }
    

}
