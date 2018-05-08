//
//  TaskCapsule.swift
//  HALP
//
//  Created by 张秦龙 on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class TaskCapsule{
    
    /*
     date object of alarm, startTime of task and end Time of Task
     */
    private let alarm:Date;
    private let startTime:Date;
    private let deadline:Date;
    private let task:Task;
    
    /* preferred not called */
    override init() {
        
    }
    
    /*
      intializer using itself
     */
    init(capsule:TaskCapsule) {
        
    }
    
    /* intializer that intialize Task based on dictionary
     and intialize alarm startTime and Deadline 
     */
    init(property:Dictionary<String,Any>) {
        
    }
    
    /* intializer that intialize Task based on the task */
    
    init(task:Task) {
        
    }
    
    
    /*
     return all fields of taskCapsule in dictionary
     */
    override func propertyGetter() -> (Dictionary<String, Any>) {
        // TODO change return value
        return Dictionary<String,Any>();
    }
    
    /*
     update taskCapsule fields using dict
    */
    override func propertySetter(dict: Dictionary<String, Any>) {
        
    }
    
    /* Helper method that return seconds as Int using DateInfo  */
    /* use first parameter as duration time not static time;
     for example.minuet = 6 .second = 5 means elapsed 6 minutes 5 seconds not
     xx:06:05, you should return 365
     description: return the elapsed time in seconds
     */
    func alarmInterValCal(duration: DateInfo)->Int {
        // TODO change return value in the end
        return 0;
    }
    
    /* Helper method that calculates the time interval between current time and desire date
     use commented intervalHelper's code if you think it would be helpful.
     return the value as seconds in Int
     parameter: date: currentDate
     parameter: rawDate: taskDate
     return value: amount of second beteen currentDate and raw
     */
    func interValCal(date:Date,rawDate:DateInfo) ->(Int) {
        
        //TODO change return value in the end.
        return 0;
    }
    
    /**
     func intervalHelper(date:Date, rawDate:DateInfo) {
     let calendarTemp = Calendar.current;
     let dateAnchor = Date();
     let isLeapYear:Bool;
     
     let monthDays:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31];
     let monthDaysLeap:[Int] = [31,29,31,30,31,30,31,31,30,31,30,31];
     
     /* gathering current time information */
     let currentMonth:Int = calendarTemp.component(.month,from:dateAnchor);
     let currentDay:Int = calendarTemp.component(.day,from:dateAnchor);
     let currentHour:Int = calendarTemp.component(.hour, from: dateAnchor);
     let currentMin: Int = calendarTemp.component(.minute,from: dateAnchor);
     let currentSec: Int = calendarTemp.component(.second,from: dateAnchor);
     
     /* gathering task time information */
     let desireMonth:Int = rawDate.month;
     let desireDay:Int = rawDate.day;
     let desireHour:Int = rawDate.hour;
     let desireMin:Int = rawDate.minute;
     let desireSec:Int = rawDate.second;
     
     /*Determine if leap year*/
     if (rawDate.year % 4 == 0){
     if (rawDate.year % 100 == 0){
     if (rawDate.year % 400 == 0){
     isLeapYear = true;
     }
     else {
     isLeapYear = false;
     }
     }
     else {
     isLeapYear = true;
     }
     }
     else {
     isLeapYear = false;
     }
     
     }
     for
     
     */
    
}
