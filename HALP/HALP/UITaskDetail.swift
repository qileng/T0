//
//  UITaskDetail.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit

// A modified UILabel that leaves some padding on left&right between boundary and texts.
class UIPaddedLabel: UILabel {
	override func drawText(in rect: CGRect) {
		let insets = UIEdgeInsets(top: 0.0, left: 7.0, bottom: 0.0, right: 7.0)
		super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
	}
}

// This view class is not self-contained. It's necessary for the view controller to pass in the
// desired frame position and a original UITask as data container&animation start point.
// It automatically performs an animation that involves a easeOut frame-changing animation the
// frame of UITask into the destination frame and change of alpha from 0 to 1.
class UITaskDetail: UIView {
	
	var task: Task?
	var originFrame: CGRect?
	let setting = UIButton()
	
	init(origin: CGRect, target: CGRect, task t: Task) {
		self.task = t
		originFrame = target
		super.init(frame: origin)
		self.layer.cornerRadius = 20
		self.clipsToBounds = true
		self.setUp()
	}
	
	// Compiler Requirement.
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// Event handler to task editing when cog is clicked
	@objc func onCogTap(_ sender: UIButton) {
		// Create an animation for Task Editing page.
		// Cog rotating animation stops in 0.5 sec, so Task Editing page should not take over until .5 sec.
	}
	
	// Called inside initializer. Create and anchor each view components one by one.
	func setUp() {
		self.alpha = 0
		let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: self.pop)
		animator.startAnimation()
		// Creating subviews
		let title = UILabel(frame: self.frame)
		title.textAlignment = .center
		title.text = self.task?.getTitle()
		title.textColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		title.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
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
		cateImg.tintColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		cate.addSubview(cateImg)
		cate.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
		
		let description = UIPaddedLabel(frame: self.frame)
		description.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
		description.text = self.task!.getDescription()
		description.textColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		description.numberOfLines = 0
		description.drawText(in: description.frame)
		description.sizeToFit()
		
		let duration = UIPaddedLabel(frame: self.frame)
		duration.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
		duration.text = "Duration: "
		self.task!.getDescriptionString(of: .duration, descriptionString: &duration.text!)
		duration.textColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		duration.drawText(in: duration.frame)
		duration.textAlignment = .left
		// Date Formatter
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "HH:mm a EEEE MMMM dd, yyyy"
		dateFormatter.timeZone = .current
		
		let scheduled = UIPaddedLabel(frame: self.frame)
		scheduled.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
		(task!.getSchedule() == 0) ? (scheduled.text = "Halp suggests: Start on ") : (scheduled.text = "From ")
		scheduled.text! += dateFormatter.string(from:  Date(timeIntervalSince1970: TimeInterval(self.task!.getScheduleStart())))
		scheduled.textColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		scheduled.drawText(in: scheduled.frame)
		scheduled.textAlignment = .left
		scheduled.numberOfLines = 0
		
		let deadline = UIPaddedLabel(frame: self.frame)
		deadline.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
		(task!.getSchedule() == 0) ? (deadline.text = "Due on: ") : (deadline.text = "To ")
		deadline.text! += dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(self.task!.getDeadline())))
		deadline.textColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		deadline.drawText(in: deadline.frame)
		deadline.textAlignment = .left
		deadline.numberOfLines = 0
		
		let img = #imageLiteral(resourceName: "Cog")
		setting.setImage(img, for: .normal)
		setting.imageView!.tintColor = TaskManager.sharedTaskManager.getTheme().background
		setting.imageView!.transform = CGAffineTransform(rotationAngle: .pi / 2.0)
		setting.addTarget(setting, action: #selector(setting.rotate), for: .touchUpInside)
		
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
		setting.imageView!.anchor(top: setting.topAnchor, left: setting.leftAnchor, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 20, height: 20, centerX: nil, centerY: nil)
	}
	
	func pop() {
		// Poping animation
		let temp = self.frame
		self.frame = self.originFrame!
		self.originFrame = temp
		self.alpha = 1
	}
	
	func dismiss() {
		// Dismissing animation
		self.frame = self.originFrame!
		self.alpha = 0
	}
}
