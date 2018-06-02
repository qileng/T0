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

let CGAffineTransformOffset = 8.00624999999999964 as CGFloat

class SummaryViewController: UIViewController {
	
	// Numeric variables
	let padding = 30 as CGFloat
	
	var data = [0,0,0,0,0,0,0,0]
	
	// Views
	var safeView: UIView = UIView()
	var chartView: UIView = UIView()
	
	let studyIcon = UIImageView(image: #imageLiteral(resourceName: "study"))
	let choreIcon = UIImageView(image: #imageLiteral(resourceName: "chore"))
	let socialIcon = UIImageView(image: #imageLiteral(resourceName: "relationship"))
	let entertainmentIcon = UIImageView(image: #imageLiteral(resourceName: "entertainment"))

	let xAxis = UILabel()
	let yAxis = UILabel()
	
	let maxY = UILabel()
	
	var studyCreated = UIBar()
	var studyCompleted = UIBar()
	var choreCreated = UIBar()
	var choreCompleted = UIBar()
	var socialCreated = UIBar()
	var socialCompleted = UIBar()
	var entertainmentCreated = UIBar()
	var entertainmentCompleted = UIBar()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Summary"
		
		// Create a smaller frame to put the chart
		let safeFrame = CGRect(x: self.view.frame.width * 0.15, y: self.view.frame.height * 0.2, width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.6)
		// Mark the region
		safeView = UIView(frame: safeFrame)
		
		self.view.addSubview(safeView)
		self.view.addSubview(studyIcon)
		self.view.addSubview(choreIcon)
		self.view.addSubview(entertainmentIcon)
		self.view.addSubview(socialIcon)
		self.view.addSubview(xAxis)
		self.view.addSubview(yAxis)
		self.view.addSubview(chartView)
		
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
	
	// Drawing everything
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		studyCreated = UIBar()
		studyCompleted = UIBar()
		choreCreated = UIBar()
		choreCompleted = UIBar()
		socialCreated = UIBar()
		socialCompleted = UIBar()
		entertainmentCreated = UIBar()
		entertainmentCompleted = UIBar()
		
		// Set up general background
		self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().tableBackground
		
		// Set axis colors
		xAxis.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		yAxis.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		updateColor()
		
		// Set up all subviews
		chartView.addSubview(studyCreated)
		chartView.addSubview(studyCompleted)
		chartView.addSubview(choreCreated)
		chartView.addSubview(choreCompleted)
		chartView.addSubview(socialCreated)
		chartView.addSubview(socialCompleted)
		chartView.addSubview(entertainmentCreated)
		chartView.addSubview(entertainmentCompleted)
		
		let iconWidth = (safeView.frame.width - padding * 4) / 4.0
		
		// draw the bars
		chartView.frame = CGRect(x: safeView.frame.origin.x + yAxis.frame.width, y: safeView.frame.origin.y, width: safeView.frame.width - yAxis.frame.width, height: safeView.frame.height - iconWidth - xAxis.frame.height)
		// All frame positions are relative to chartView
		for (index, subview) in [studyCreated, choreCreated, socialCreated, entertainmentCreated].enumerated() {
			subview.frame = CGRect(x: padding / 2 + (padding + iconWidth) * CGFloat(index) - CGAffineTransformOffset, y: chartView.frame.height, width: iconWidth / 2, height: -2)
			subview.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
		}
		
		for (index, subview) in [studyCompleted, choreCompleted, socialCompleted, entertainmentCompleted].enumerated() {
			subview.frame = CGRect(x: padding / 2 + (padding + iconWidth) * CGFloat(index) + iconWidth / 2 * 0.75 - CGAffineTransformOffset, y: chartView.frame.height, width: iconWidth / 2, height: -2)
			subview.layer.anchorPoint = CGPoint(x: 0.0, y: 1.0)
		}
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		updateColor()
		let settingDAO = SettingDAO()
        var summaryString: String = "0,0,0,0,0,0,0,0"
        do {
            let setting = try settingDAO.fetchSettingFromLocalDB(settingId: TaskManager.sharedTaskManager.getUser().getUserID())
            summaryString = setting[2] as! String
        } catch {
            print("cannot initialize summary report")
        }
        
		self.populateDate(summaryString)
		let scale = chartView.frame.height * 0.75 / CGFloat(data.max()!)
		maxY.text = String(data.max()!, radix: 10)
		maxY.textAlignment = .center
		self.view.addSubview(maxY)
		if data.max()! == 0 {
			maxY.anchor(top: nil, left: nil, right: yAxis.leftAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 3, bottomConstant: 0, width: 30, height: 20, centerX: nil, centerY: nil)
		} else {
			maxY.anchor(top: yAxis.topAnchor, left: nil, right: yAxis.leftAnchor, bottom: nil, topConstant: yAxis.frame.height * 0.25, leftConstant: 0, rightConstant: 3, bottomConstant: 0, width: 30, height: 20, centerX: nil, centerY: nil)
		}
		
		// Do animation.
		for (index,subview) in self.chartView.subviews.enumerated() {
			if index == 8 {
				break
			}
			(subview as! UIBar).size = CGFloat(data[index]) * scale
			let animator = UIViewPropertyAnimator(duration: 0.8, curve: .linear, animations: (subview as! UIBar).grow)
			if data[index] != 0 {
				animator.startAnimation()
			}
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		for subview in self.chartView.subviews {
			subview.removeFromSuperview()
		}
	}
	
	func populateDate(_ s: String) {
		let substrings = s.split(separator: ",")
		for (index,substring) in substrings.enumerated() {
			self.data[index] = Int(substring)!
		}
	}
	
	
	private func updateColor() {
		// Set image colors
		studyIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		choreIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		socialIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		entertainmentIcon.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
		// Set bar colors
		studyCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		studyCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		choreCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		choreCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		socialCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		socialCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
		entertainmentCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
		entertainmentCompleted.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
	}
}
