//
//  Task.swift
//  HALP
//
//  Created by 张秦龙 on 5/5/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation


class Task {
    //title of tasks
    private var title: String;
    private var taskDescription: String;
    private var taskPriority: Double;
    private var alarm:DateInfo;
    private var location:String;
    private var category:Category;
    private var deadline:DateInfo;
    private var softDeadline:DateInfo;
    private var schedule:DateInfo;
    private var duration: DateInfo;
    
    // initailize object using itself
    init(task:Task) {
        
    }
    
    
    // extremely not recommend to use this intializer
    init() {
        self.title = "";
        self.taskDescription = "";
        self.alarm = DateInfo();
        self.location = "";
        self.category = Category.chore;
        self.deadline = DateInfo();
        self.softDeadline = DateInfo();
        self.schedule = DateInfo();
        self.duration = DateInfo();
        self.taskPriority = 0;
    }
    
    /*
     Initialize based on  property stored in dictioanry
     */
    init(_ stringType:Dictionary<String,String>,_ priority:Double,
         _ DateInfoType:Dictionary<String,DateInfo>, _ cate:Category) {
        self.title = stringType["title"]!;
        self.taskDescription = stringType["taskDescription"]!;
        self.location = stringType["location"]!;
        self.taskPriority = priority;
        self.alarm = DateInfoType["alarm"]!;
        self.deadline = DateInfoType["deadline"]!;
        self.softDeadline = DateInfoType["softDeadline"]!;
        self.schedule = DateInfoType["schedule"]!;
        self.duration = DateInfoType["duration"]!;
        self.category = cate;
    }
    /*
     intialize based on property provided by users
     */
    init(Title title:String, TaskD taskD:String, TaskP taskP:Double, Alarm alarm:DateInfo, Location location:String,
         Category category:Category, Deadline deadline:DateInfo, SoftDeadline softDeadline:DateInfo,
         Schedule schedule:DateInfo, Duration duration:DateInfo){
        self.title = title;
        self.taskDescription = taskD;
        self.taskPriority = taskP;
        self.alarm = alarm;
        self.location = location;
        self.category = category;
        self.deadline = deadline;
        self.softDeadline = softDeadline;
        self.schedule = schedule;
        self.duration = duration;
    }
    /*
    return all fields in one dictioanry
    */
    func propertyGetter()->(Dictionary<String, Any>){
        let dict: [String:Any] = ["title":self.title,"taskD":self.taskDescription,"location":self.location,
                                  "taskP":self.taskPriority, "alarm":self.alarm,"deadline":self.softDeadline,
                                  "schedule":self.schedule,"duration":self.duration,"category":self.category,
                                  "softD":self.softDeadline];
        return dict;
    }
    
    /*
      set fields using passing in dictionary
    */
    func propertySetter(_ dict:Dictionary<String,Any>) {
        for (key,value) in dict {
            switch key {
            case "title":
                 self.title = value as! String;
            case "taskD":
                self.taskDescription = value as! String;
            case "location":
                self.location = value as! String;
            case "taskP":
                self.taskPriority = value as! Double;
            case "alarm":
                self.alarm = value as! DateInfo;
            case "deadline":
                self.deadline = value as! DateInfo;
            case "schedule":
                self.schedule = value as! DateInfo;
            case "duration":
                self.duration = value as! DateInfo;
            case "category":
                self.category = value as! Category;
            case "softD":
                self.softDeadline = value as! DateInfo;
            default:
                print("you must enter the wrong key");
            }
        }
    }
    
    
    
    
}
