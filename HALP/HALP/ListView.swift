//
//  ListView.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit
import CoreGraphics

class ListViewController: UIViewController, UIGestureRecognizerDelegate {
	
	// link this var to the label in StoryBoard
	
	var detailDisplay = false
	var taskWidth: CGFloat = 0.0
	var taskHeight: CGFloat = 0.0
	var taskCount: CGFloat = 8.0							// Maybe put this into setting.
	
	let topMargin: CGFloat = 50.0							// Top margin
	let verticalPadding: CGFloat = 15.0						// Vertical padding
	let horizontalMargin: CGFloat = 30.0					// Horizontal margin
	let bottomMargin: CGFloat = 30.0						// Bottom margin
	
    @IBAction func AddTask(_ sender: Any) {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "TaskEditViewController"))!, animated: true, completion: nil)
    }
	
    override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
		self.view.gestureRecognizers![0].delegate = self
		// Do calculations of widths and heights
		let n = taskCount
		let p_v = verticalPadding
		let m_h = horizontalMargin
		taskHeight = (self.view.frame.height - (n-1)*p_v - topMargin - bottomMargin) / n
		taskWidth = (self.view.frame.width - 2*m_h)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if detailDisplay {
			self.view.subviews.last?.removeFromSuperview()
			self.deTransparentizeAllTasks()
			detailDisplay = false
		}
		if self.view.subviews.count != 1 {
			return
		}

		let tasks = TaskManager.sharedTaskManager.getTasks()
		var lastSubview: UITask? = nil
		var index = 0
		for task in tasks {
			// Do calculation on origins
			let origin_x = horizontalMargin
			let origin_y = topMargin + (verticalPadding+taskHeight) * CGFloat(index)
			let frame = CGRect(x: origin_x, y: origin_y, width: taskWidth, height: taskHeight)
			let subview = UITask(frame: frame, task: task)
			self.view.addSubview(subview)
			index += 1
		}
	}	
	
	@objc func onTap(_ sender: UITapGestureRecognizer) {
		for subview in self.view.subviews {
			if type(of: subview) == UITask.self && !detailDisplay {
				let location = sender.location(in: subview)
				if subview.point(inside: location, with: nil) {
					print((subview as! UITask).task?.getTitle(), "tapped!")
					self.transparentizeAllTasks()
					subview.isHidden = true
					let subframe = CGRect(x: self.view.frame.width*0.1,y: self.view.frame.height*0.2,width: self.view.frame.width*0.8,height: self.view.frame.height*0.6)
					let detailView = UITaskDetail(frame: subframe, task: subview as! UITask)
					self.view.addSubview(detailView)
					detailDisplay = true
				}
			}
			
			if type(of: subview) == UITaskDetail.self && detailDisplay {
				let location = sender.location(in: subview)
				if !subview.point(inside: location, with: nil) {
					self.view.subviews.last?.removeFromSuperview()
					self.deTransparentizeAllTasks()
					detailDisplay = false
				}
			}
		}
	}
	
	func transparentizeAllTasks() {
		for subview in self.view.subviews {
			if (type(of: subview) == UITask.self) {
				subview.alpha = 0.2
			}
		}
	}
	
	func deTransparentizeAllTasks() {
		for subview in self.view.subviews {
			if (type(of: subview) == UITask.self) {
				subview.alpha = 1
				subview.isHidden = false
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}
