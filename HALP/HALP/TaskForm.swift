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
	
	// Validate functions.
	func validateTitle() -> (Bool){
		return self.getTitle().contains("`")
	}
	
	func validateDescription() -> (Bool) {
		return self.getDescription().contains("`")
	}
}
