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

	// Initializer used in adding a task.
	init(Title title: String = "", Description taskD: String = "", Category category: Category = Category.Study_Work,
		 Alarm alarm: Int32 = 0, Deadline deadline: Date? = nil, SoftDeadline softDeadline: Date? = nil,
		 Schedule schedule: Date? = nil, Duration duration: Int32 = 0,
		 UserID uid: Int64) {
		let ddl_stamp = Int32((deadline?.timeIntervalSince1970)!)
		let sddl_stamp = Int32((softDeadline?.timeIntervalSince1970)!)
		let fixed_stamp = Int32((schedule?.timeIntervalSince1970)!)
		let alarm_stamp = -alarm	
		super.init(Title: title, Description: taskD, Category: category, Alarm: alarm_stamp, Deadline: ddl_stamp, SoftDeadline: sddl_stamp, Schedule: fixed_stamp, Duration: duration, UserID: uid)
	}
	
	// Validate functions.
	func validateTitle() -> (Bool){
		return self.getTitle().contains("`")
	}
	
	func validateDescription() -> (Bool) {
		return self.getDescription().contains("`")
	}
}
