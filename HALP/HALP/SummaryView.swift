//
//  SummaryView.swift
//  HALP
//
//  Created by Qihao Leng on 5/31/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class SummaryViewController: UIViewController {
	
	// Numeric variables
	let padding = 30 as CGFloat
	
	var study: (Int, Int) = (0,0)
	var chore: (Int, Int) = (0,0)
	var social: (Int, Int) = (0,0)
	var entertainment: (Int, Int) = (0,0)
	
	// Views
	var safeView: UIView = UIView()
	var chartView: UIView = UIView()
	
	let studyIcon = UIImageView(image: #imageLiteral(resourceName: "study"))
	let choreIcon = UIImageView(image: #imageLiteral(resourceName: "chore"))
	let socialIcon = UIImageView(image: #imageLiteral(resourceName: "relationship"))
	let entertainmentIcon = UIImageView(image: #imageLiteral(resourceName: "entertainment"))

	let xAxis = UILabel()
	let yAxis = UILabel()
	
	let studyCreated = UILabel()
	let studyCompleted = UILabel()
	let choreCreated = UILabel()
	let choreCompleted = UILabel()
	let socialCreated = UILabel()
	let socialCompleted = UILabel()
	let entertainmentCreated = UILabel()
	let entertainmentCompleted = UILabel()
	
	// Drawing everything
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Set up general background
		self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		self.navigationItem.title = "Summary"
		
		// Set image colors
		studyIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		choreIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		socialIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		entertainmentIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		// Set axis colors
		xAxis.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		yAxis.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		// Set bar colors
		studyCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		studyCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		choreCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		choreCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		socialCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		socialCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		entertainmentCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		entertainmentCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		
		// Create a smaller frame to put the chart
		let safeFrame = CGRect(x: self.view.frame.width * 0.15, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.6)
		// Mark the region
		safeView = UIView(frame: safeFrame)
		
		// Set up all subviews
		self.view.addSubview(safeView)
		self.view.addSubview(studyIcon)
		self.view.addSubview(choreIcon)
		self.view.addSubview(entertainmentIcon)
		self.view.addSubview(socialIcon)
		self.view.addSubview(xAxis)
		self.view.addSubview(yAxis)
		self.view.addSubview(chartView)
		chartView.addSubview(studyCreated)
		chartView.addSubview(studyCompleted)
		chartView.addSubview(choreCreated)
		chartView.addSubview(choreCompleted)
		chartView.addSubview(socialCreated)
		chartView.addSubview(socialCompleted)
		chartView.addSubview(entertainmentCreated)
		chartView.addSubview(entertainmentCompleted)
		
		// Layout all the icons
		let iconWidth = (safeView.frame.width - padding * 4) / 4.0

		studyIcon.anchor(top: nil, left: safeView.leftAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding / 2, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		choreIcon.anchor(top: nil, left: studyIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		socialIcon.anchor(top: nil, left: choreIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		entertainmentIcon.anchor(top: nil, left: socialIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
	
		// draw axis
		xAxis.anchor(top: nil, left: safeView.leftAnchor, right: nil, bottom: studyIcon.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: safeFrame.width , height: 1, centerX: nil, centerY: nil)
		yAxis.anchor(top: safeView.topAnchor, left: nil, right: safeView.leftAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 1, height: 0, centerX: nil, centerY: nil)
		
		// draw the bars
		chartView.frame = CGRect(x: safeView.frame.origin.x + yAxis.frame.width, y: safeView.frame.origin.y, width: safeView.frame.width - yAxis.frame.width, height: safeView.frame.height - iconWidth - xAxis.frame.height)
		// Relative to chartView
		studyCreated.frame = CGRect(x: padding / 2, y: chartView.frame.height, width: iconWidth / 2, height: -2)
		studyCreated.alpha = 1
		print(chartView.frame)
		/*
		studyCreated.anchor(top: nil, left: nil, right: studyIcon.centerXAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: -5, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		studyCompleted.anchor(top: nil, left: studyIcon.centerXAnchor, right: nil, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: -5, rightConstant: 0, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		choreCreated.anchor(top: nil, left: nil, right: choreIcon.centerXAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: -5, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		choreCompleted.anchor(top: nil, left: choreIcon.centerXAnchor, right: nil, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: -5, rightConstant: 0, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		socialCreated.anchor(top: nil, left: nil, right: socialIcon.centerXAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: -5, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		socialCompleted.anchor(top: nil, left: socialIcon.centerXAnchor, right: nil, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: -5, rightConstant: 0, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		entertainmentCreated.anchor(top: nil, left: nil, right: entertainmentIcon.centerXAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: -5, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		entertainmentCompleted.anchor(top: nil, left: entertainmentIcon.centerXAnchor, right: nil, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: -5, rightConstant: 0, bottomConstant: 2, width: studyIcon.frame.width / 2, height: 2, centerX: nil, centerY: nil)
		*/
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Do animation.
		let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: studyCreated.grow)
		animator.startAnimation()
	}
}
