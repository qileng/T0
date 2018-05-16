//
//  UITask.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class UITask: UIView {
	
	var title: UILabel?
	var task: Task?
	
	// Initializer
	init(frame: CGRect, task t: Task) {
		self.task = t
		self.title = UILabel(frame: frame)
		super.init(frame: frame)
		self.setUp()

	}
	
	// No use. Compiler requirement.
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Setting up the label.
	func setUp() {
		self.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		self.title?.text = self.task?.getTitle()
		self.title?.textAlignment = .center
		self.title?.textColor = TaskManager.sharedTaskManager.getTheme().text
		self.addSubview(title!)
	}
}
