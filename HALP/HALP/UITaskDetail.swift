//
//  UITaskDetail.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit


class UIPaddedLabel: UILabel {
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 7.0)
		super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
	}
}


class UITaskDetail: UIView {
	
	var task: Task?
	
	init(frame: CGRect, task t: UITask) {
		self.task = t.task
		super.init(frame: frame)
		self.frame = frame
		self.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
		self.layer.cornerRadius = 20
		self.clipsToBounds = true
		
		// Creating subviews
		let title = UILabel(frame: self.frame)
		title.textAlignment = .center
		title.text = self.task?.getTitle()
		title.textColor = TaskManager.sharedTaskManager.getTheme().text
		title.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		title.font = (UIFont.preferredFont(forTextStyle: .headline)).withSize(20.0)
		
		let cateImg: UIImageView
		switch self.task!.getCategory() {
			case Category.Study_Work:
				cateImg = UIImageView(image: UIImage(named: "study"))
			case .Entertainment:
				cateImg = UIImageView(image: UIImage(named: "entertainment"))
			case .Chore:
				cateImg = UIImageView(image: UIImage(named: "chore"))
			case .Relationship:
				cateImg = UIImageView(image: UIImage(named: "relationship"))
		}
		let cate = UIView(frame: self.frame)
		cate.addSubview(cateImg)
		cate.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		
		let description = UIPaddedLabel(frame: self.frame)
		description.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		description.text = "Suppose to be full description of the task, which is not hard coded into database yet. Just trying to fill the frame to test UILabel's attributes blahblahblahblah more more more more good enough!"
		description.textColor = TaskManager.sharedTaskManager.getTheme().text
		description.numberOfLines = 0
		description.font = UIFont(name: "MarkerFelt-Thin", size: UIFont.systemFontSize)
		description.drawText(in: description.frame)
		description.sizeToFit()
		
		let duration = UIPaddedLabel(frame: self.frame)
		duration.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		duration.text = "Duration: 2 hours (sample)"
		duration.textColor = TaskManager.sharedTaskManager.getTheme().text
		duration.drawText(in: duration.frame)
		duration.textAlignment = .left
		duration.font = UIFont(name: "GillSans-LightItalic", size: UIFont.systemFontSize)
		
		let scheduled = UIPaddedLabel(frame: self.frame)
		scheduled.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		scheduled.text = "HALP suggests you start in: blahblahblah"
		scheduled.textColor = TaskManager.sharedTaskManager.getTheme().text
		scheduled.drawText(in: scheduled.frame)
		scheduled.textAlignment = .left
		scheduled.font = UIFont(name: "Noteworthy-Bold", size: UIFont.systemFontSize)
		
		let deadline = UIPaddedLabel(frame: self.frame)
		deadline.backgroundColor = TaskManager.sharedTaskManager.getTheme().taskBackground
		deadline.text = "Remaining time: xxxx / Due on: xx:xx xx/xx"
		deadline.textColor = TaskManager.sharedTaskManager.getTheme().text
		deadline.drawText(in: deadline.frame)
		deadline.textAlignment = .left
		deadline.font = UIFont(name: "AmericanTypewriter", size: UIFont.systemFontSize)
		
		let setting = UIButton()
		setting.setImage(UIImage(named: "Cog"), for: .normal)
		setting.addTarget(self, action: #selector(self.onCogTap), for: .touchUpInside)
		
		// Adding subviews.
		self.addSubview(title)
		self.addSubview(cate)
		self.addSubview(description)
		self.addSubview(duration)
		self.addSubview(scheduled)
		self.addSubview(deadline)
		self.addSubview(setting)
		
		// Layout subviews
		let padding: CGFloat = 2.0
		title.anchor(top: self.topAnchor, left: self.leftAnchor, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width*0.65-padding/2, height: self.frame.height*0.15-padding/2, centerX: nil, centerY: nil)
		cate.anchor(top: self.topAnchor, left: title.rightAnchor, right: nil, bottom: nil, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: self.frame.width*0.35-padding/2, height: self.frame.height*0.15-padding/2, centerX: nil, centerY: nil)
		cateImg.anchor(top: nil, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 30, height: 30, centerX: cate.centerXAnchor, centerY: cate.centerYAnchor)
		description.anchor(top: title.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: padding, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width, height: self.frame.height*0.4-padding, centerX: self.centerXAnchor, centerY: nil)
		duration.anchor(top: description.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: padding, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width, height: self.frame.height*0.15-padding, centerX: self.centerXAnchor, centerY: nil)
		scheduled.anchor(top: duration.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: padding, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width, height: self.frame.height*0.15-padding, centerX: self.centerXAnchor, centerY: nil)
		deadline.anchor(top: scheduled.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: padding, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.frame.width, height: self.frame.height*0.15-padding/2, centerX: self.centerXAnchor, centerY: nil)
		setting.anchor(top: self.topAnchor, left: self.leftAnchor, right: nil, bottom: nil, topConstant: 2.68, leftConstant: 2.68, rightConstant: 0, bottomConstant: 0, width: 20, height: 20, centerX: nil, centerY: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	@objc func onCogTap(_ sender: UIButton) {
		print("proceed to edit task!")
	}	
}
