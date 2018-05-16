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
	
    @IBAction func AddTask(_ sender: Any) {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "TaskEditViewController"))!, animated: true, completion: nil)
    }
    override func viewDidLoad() {
		super.viewDidLoad()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
		self.view.gestureRecognizers![0].delegate = self
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
		let taskViewWidth = self.view.frame.width * 0.8
		let taskViewHeight = self.view.frame.width * 0.1
		let tasks = TaskManager.sharedTaskManager.getTasks()
		let frame = CGRect(x: 0, y: 0, width: taskViewWidth, height: taskViewHeight)
		var lastSubview: UITask? = nil
		for task in tasks {
			let subview = UITask(frame: frame, task: task)
			subview.backgroundColor = TaskManager.sharedTaskManager.getTheme().task
			self.view.addSubview(subview)
			if lastSubview == nil {
				subview.anchor(top: self.view.topAnchor, left: nil, right: nil, bottom: nil, topConstant: 40, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: taskViewWidth, height: taskViewHeight, centerX: self.view.centerXAnchor, centerY: nil)
			} else {
				subview.anchor(top: lastSubview?.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: 20, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: taskViewWidth, height: taskViewHeight, centerX: self.view.centerXAnchor, centerY: nil)
			}
			lastSubview = subview
		}
	}	
	
	@objc func onTap(_ sender: UITapGestureRecognizer) {
		var cancel: Bool = true
		for subview in self.view.subviews {
			if type(of: subview) != UITask.self {
				continue
			}
			let location = sender.location(in: subview)
			if subview.point(inside: location, with: nil) && !detailDisplay {
				print((subview as! UITask).task?.getTitle(), "tapped!")
				cancel = false
				self.transparentizeAllTasks()
				let subframe = CGRect(origin: self.view.frame.origin, size: CGSize(width:self.view.frame.width * 0.85, height: self.view.frame.height * 0.7))
				let detailView = UITaskDetail(frame: subframe, task: subview as! UITask)
				self.view.addSubview(detailView)
				detailDisplay = true
				detailView.anchor(top: self.view.topAnchor, left: nil, right: nil, bottom: nil, topConstant: 60, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: self.view.frame.width*0.85, height: self.view.frame.height*0.7, centerX: self.view.centerXAnchor, centerY: nil)
			}
		}
		
		if detailDisplay && cancel {
			self.view.subviews.last?.removeFromSuperview()
			self.deTransparentizeAllTasks()
			detailDisplay = false
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
			}
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
}
