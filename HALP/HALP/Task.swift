//
//  Task.swift
//  HALP
//
//  Created by 张秦龙 on 5/5/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

class Task {
    var title: String;
    var taskDescription: String;
    var taskPriority: Double;
    var alarm:DateInfo;
    var location:String;
    var category:Category;
    var deadline:DateInfo;
    var softDeadline:DateInfo;
    var schedule:DateInfo;
    
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
        self.category = cate;
    }
    
    
    
    
    
    
}
