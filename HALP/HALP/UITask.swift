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
	init(frame: CGRect, task t: Task) {
		self.title = UILabel(frame: frame)
		self.title?.textAlignment = .center
		self.title?.textColor = UIColor(hex: 0xffffff)
		self.task = t
		self.title?.text = self.task?.getTitle()
		super.init(frame: frame)
		self.frame = frame
		self.addSubview(title!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

}
