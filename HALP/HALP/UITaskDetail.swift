//
//  UITaskDetail.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit

class UITaskDetail: UIView {
	var title: UILabel?
	var deadline: UILabel?
	var task: Task?
	init(frame: CGRect, task t: UITask) {
		self.title = UILabel()
		self.title?.textAlignment = .center
		self.title?.textColor = UIColor(hex: 0xffffff)
		self.deadline = UILabel()
		self.deadline?.textAlignment = .center
		self.deadline?.textColor = UIColor(hex: 0xffffff)
		self.task = t.task
		self.title?.text = self.task?.getTitle()
		self.deadline?.text = Date(timeIntervalSince1970:  TimeInterval((self.task?.getDeadline())!)).description(with: .current)
		super.init(frame: frame)
		self.frame = frame
		self.addSubview(title!)
		self.addSubview(deadline!)
		self.title?.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width, height: self.frame.height / 2.0, centerX: self.centerXAnchor, centerY: nil)
		self.deadline?.anchor(top: self.title?.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width, height: self.frame.height / 2.0, centerX: self.centerXAnchor, centerY: nil)
		self.backgroundColor = UIColor(hex: 0x176a90)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
}
