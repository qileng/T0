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
		
		// Layout all the icons
		let iconWidth = (safeView.frame.width - padding * 4) / 4.0

		studyIcon.anchor(top: nil, left: safeView.leftAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding / 2, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		choreIcon.anchor(top: nil, left: studyIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		socialIcon.anchor(top: nil, left: choreIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		entertainmentIcon.anchor(top: nil, left: socialIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
	
		// draw axis
		xAxis.anchor(top: nil, left: safeView.leftAnchor, right: nil, bottom: studyIcon.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: safeFrame.width , height: 1, centerX: nil, centerY: nil)
		yAxis.anchor(top: safeView.topAnchor, left: nil, right: safeView.leftAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 1, height: 0, centerX: nil, centerY: nil)
	}
}
