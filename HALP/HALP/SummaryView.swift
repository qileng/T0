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

    let labelCreated = UILabel()
    let labelDone = UILabel()
	let maxY = UILabel()
	
	var studyCreated = UIBar()
	var studyCompleted = UIBar()
	var choreCreated = UIBar()
	var choreCompleted = UIBar()
	var socialCreated = UIBar()
	var socialCompleted = UIBar()
	var entertainmentCreated = UIBar()
	var entertainmentCompleted = UIBar()
    var taskCreated = UIBar()
    var taskDone = UIBar()
    
	var total = [UIBarLabel](repeating: UIBarLabel(), count: 8)
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
		self.view.addSubview(labelCreated)
        self.view.addSubview(labelDone)
        
		// Layout all the icons
		let iconWidth = (safeView.frame.width - padding * 4) / 4.0
		studyIcon.anchor(top: nil, left: safeView.leftAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding / 2, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		choreIcon.anchor(top: nil, left: studyIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		socialIcon.anchor(top: nil, left: choreIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		entertainmentIcon.anchor(top: nil, left: socialIcon.rightAnchor, right: nil, bottom: safeView.bottomAnchor, topConstant: 0, leftConstant: padding, rightConstant: 0, bottomConstant: 0, width: iconWidth, height: iconWidth, centerX: nil, centerY: nil)
		
		// draw axis
		xAxis.anchor(top: nil, left: safeView.leftAnchor, right: nil, bottom: studyIcon.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: safeFrame.width , height: 1, centerX: nil, centerY: nil)
        yAxis.anchor(top: safeView.topAnchor, left: nil, right: safeView.leftAnchor, bottom: xAxis.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: 1, height: 0, centerX: nil, centerY: nil)
        yAxis.alpha = 0
        // draw labels
        
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		for subview in self.total {
			subview.removeFromSuperview()
		}
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
		self.view.addSubview(taskCreated)
        self.view.addSubview(taskDone)
		let iconWidth = (safeView.frame.width - padding * 4) / 4.0
		
		// draw the bars
		chartView.frame = CGRect(x: safeView.frame.origin.x + yAxis.frame.width, y: safeView.frame.origin.y, width: safeView.frame.width - yAxis.frame.width, height: safeView.frame.height - iconWidth - xAxis.frame.height)
        labelCreated.text = "Tasks Created"
        labelDone.text = "Tasks Done"
        
        taskCreated.anchor(top: self.view.topAnchor, left: self.studyIcon.leftAnchor, right: nil, bottom: nil, topConstant: self.view.frame.width * 0.1, leftConstant: 0, rightConstant: 0, bottomConstant: 0,  width: self.view.frame.width * 0.05, height: self.view.frame.width * 0.05, centerX: nil, centerY: nil)
        taskDone.anchor(top: taskCreated.bottomAnchor, left: self.studyIcon.leftAnchor, right: nil, bottom: nil, topConstant: 5, leftConstant: 0, rightConstant: 0, bottomConstant: 0,  width: self.view.frame.width * 0.05, height: self.view.frame.width * 0.05, centerX: nil, centerY: nil)
        
        labelCreated.anchor(top: taskCreated.topAnchor, left: taskCreated.rightAnchor, right: nil, bottom: nil, topConstant: 0, leftConstant: 5, rightConstant: 0, bottomConstant: 0, width: 0, height: self.view.frame.width * 0.05, centerX: nil, centerY: nil)
        
        labelDone.anchor(top: taskDone.topAnchor, left: taskDone.rightAnchor, right: nil, bottom: nil, topConstant: 0, leftConstant: 5, rightConstant: 0, bottomConstant: 0, width: 0, height: self.view.frame.width * 0.05, centerX: nil, centerY: nil)
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
		//self.view.
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
		let scale = chartView.frame.height * 1 / CGFloat(data.max()!)
		
		// Do animation.
		for (index,subview) in self.chartView.subviews.enumerated() {
			if index == 8 {
				break
			}
			(subview as! UIBar).size = CGFloat(data[index]) * scale
            
            let total_i = UIBarLabel()
			total[index] = total_i
            if(data[index] == 0)
            {
                continue
            }
            total_i.height = (subview as! UIBar).size
			total_i.text = String(data[index], radix: 10)
			let fontSize: CGFloat = 11.0
			total_i.font = UIFont.preferredFont(forTextStyle: .headline).withSize(fontSize)
			total_i.adjustsFontSizeToFitWidth = true
			total_i.textAlignment = .center
            self.view.addSubview(total_i)
            switch (index)
            {
            case 0:
				total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 1:
				total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 2:
                total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 3:
                total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 4:
                total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 5:
                total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 6:
                total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            case 7:
                total_i.frame = self.chartView.convert(CGRect(x: subview.frame.origin.x, y: subview.frame.origin.y - 20 - 2, width: subview.frame.width, height: 20), to: self.view)
            default:
				print("default")
            }
			let barAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .linear, animations: (subview as! UIBar).grow)
			let labelAnimator = UIViewPropertyAnimator(duration: 0.8, curve: .linear, animations: total_i.move)
			if data[index] != 0 {
				barAnimator.startAnimation()
				labelAnimator.startAnimation()
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
        taskDone.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.8)
        taskCreated.backgroundColor = TaskManager.sharedTaskManager.getTheme().background.withAlphaComponent(0.4)
	}
}
