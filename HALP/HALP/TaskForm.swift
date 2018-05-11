//
//  TaskForm.swift
//  HALP
//
//  Created by Qinlong on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

// Renamed from TaskCapsule to match design pattern of user and setting.
// Subclass of task.
// This class does not handle input coversion. That should be handled in ViewController.
final class TaskForm: Task {

	// The general initializer for TaskForm.
	// The principle here is that if a field is not passed in, then no change was made to that field.
	// First parameter is the task being edited.
	// In add task, call the inherited general initializer in Task.
	init(Task t: Task, Title title: String = "", Description taskD: String = "",
		 Category category: Category,
		 Alarm alarm: Int = 0, Deadline deadline: Int = 0, SoftDeadline softDeadline: Int = 0,
		 Schedule schedule: Int = 0, Duration duration: Int = 0, Priority taskP: Double = 0,
		 Schedule_start scheduled_start: Int = 0, ID tid: Int64 = 0) {
		dict = t.propertyGetter()
		self.title = (title == "") ? t["title"] : title
		self.taskDescription = taskD ? t["taskDescription"] : taskD
		// TODO: follow the above codes.
		self.taskPriority = taskP
		self.alarm = alarm
		self.category = category
		self.deadline = deadline
		self.softDeadline = softDeadline
		self.schedule = schedule
		self.duration = duration
		self.scheduled_start = scheduled_start
		self.taskID = tid
	}
	
	/* Helper method that return seconds as Int using DateInfo  */
	/* use first parameter as duration time not static time
	for example.minuet = 6 .second = 5 means elapsed 6 minutes 5 seconds not
	xx:06:05, you should return 365
	description: return the elapsed time in seconds
	*/
	func alarmInterValCal(duration: DateInfo)->Int {
		// TODO change return value in the end
		return 0
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
		return 0
	}
	
	/**
	func intervalHelper(date:Date, rawDate:DateInfo) {
	let calendarTemp = Calendar.current
	let dateAnchor = Date()
	let isLeapYear:Bool
	
	let monthDays:[Int] = [31,28,31,30,31,30,31,31,30,31,30,31]
	let monthDaysLeap:[Int] = [31,29,31,30,31,30,31,31,30,31,30,31]
	
	/* gathering current time information */
	let currentMonth:Int = calendarTemp.component(.month,from:dateAnchor)
	let currentDay:Int = calendarTemp.component(.day,from:dateAnchor)
	let currentHour:Int = calendarTemp.component(.hour, from: dateAnchor)
	let currentMin: Int = calendarTemp.component(.minute,from: dateAnchor)
	let currentSec: Int = calendarTemp.component(.second,from: dateAnchor)
	
	/* gathering task time information */
	let desireMonth:Int = rawDate.month
	let desireDay:Int = rawDate.day
	let desireHour:Int = rawDate.hour
	let desireMin:Int = rawDate.minute
	let desireSec:Int = rawDate.second
	
	/*Determine if leap year*/
	if (rawDate.year % 4 == 0){
	if (rawDate.year % 100 == 0){
	if (rawDate.year % 400 == 0){
	isLeapYear = true
	}
	else {
	isLeapYear = false
	}
	}
	else {
	isLeapYear = true
	}
	}
	else {
	isLeapYear = false
	}
	
	}
	for
	
	*/
	
}
