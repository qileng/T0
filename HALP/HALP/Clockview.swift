//
//  Clockview.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//
//  Edited by Anagha Subramanian and Kelly Zhang
//

import UIKit
import CoreGraphics

//Extension class for the CollectionView on ClockView screen
extension ClockViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	// Protocal: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return clockTasks[currentIndex!].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "clockTaskCell", for: indexPath) as! ClockTaskCell
        
		let task = clockTasks[currentIndex!][indexPath.row]
        cell.displayContent(task: task)
        
		return cell
    }
	
	// Protocol: UICollectionViewDelegate
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		// Retrieve the cell selected
		let cell = collectionView.cellForItem(at: indexPath)!
		// Retrieve the task selected
		let task = clockTasks[currentIndex!][indexPath.row]
		
		// Temporarily remove the container view of the clock hands
		self.removeContainerView()
		// Pop detail page
		// Calculate frame position since cell.frame is so dumb that it won't give me the correct position
		let originFrame = self.calculateFrame(collectionView, cell)
		let targetFrame = CGRect(x: self.view.frame.width*0.1, y: self.view.frame.width*0.1, width: self.view.frame.width*0.8, height: self.view.frame.height*0.8)
		self.taskDetail = UITaskDetail(origin: originFrame, target: targetFrame, task: task)
		self.transparentizeBackground()
		self.view.addSubview(self.taskDetail!)
		// Setup tap recognizer
		let TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapWhileDetailDisplayed))
		self.view.addGestureRecognizer(TapRecognizer)
		// set up cog button handler
		self.taskDetail!.setting.addTarget(self, action: #selector(onCogTap(_:)), for: .touchUpInside)
	}
	
	func calculateFrame(_ collectionView: UICollectionView, _ cell: UICollectionViewCell) -> CGRect {
		// There is no good way to determine a cell's position. Their order in the array seems to be highly dependent on the speed user scroll the collectionView.
		// Here we use a trial&fail method.
		// IMPORTANT: All calculation based on the fact that margin and padding are the same in all direction. This will certainly fail as soon as inconsistency occurs.
		let index = collectionView.indexPath(for: cell)!.row
		let origin: CGPoint
		let padding: CGFloat
		var row = 0.0 as CGFloat
		var column = 0.0 as CGFloat
		// First, for all cells with even indexPath, i.e. on the left.
		if index % 2 == 0 {
			// Try the cell above it
			let trialCell = collectionView.cellForItem(at: IndexPath(row: index - 2, section: 0))
			padding = cell.frame.origin.x
			// If the cell above it is visible, it means the cell is in second row and first column, which is the third visible cell.
			// Else it's the first visible cell
			if trialCell != nil {
				row = 1.0
				column = 0.0
			} else {
				row = 0.0
				column = 0.0
			}
		} else {
			// Same thing for all cells on the right.
			let trialCell = collectionView.cellForItem(at: IndexPath(row: index - 2, section: 0))
			padding = (cell.frame.origin.x - cell.frame.width) / 2
			// If the cell above it is visible, it means the cell is in second row and second column, which is the fourth visible cell.
			// Else it's the second visible cell
			if trialCell != nil {
				row = 1.0
				column = 1.0
			} else {
				row = 0.0
				column = 1.0
			}
		}
		// Calculate frame position accordingly
		origin = CGPoint(x: padding + column * (padding + cell.frame.width) + collectionView.frame.origin.x, y: padding + row * (padding + cell.frame.height) + collectionView.frame.origin.y)
		return CGRect(origin: origin, size: cell.frame.size)
	}
}

//Normal ClockViewController class begins here
class ClockViewController: UIViewController, CAAnimationDelegate {

    var clockTasks = Array(repeating: [Task](), count: 12)
	var currentIndex: Int?
    
    var taskCollection: UICollectionView!
	var taskDetail: UITaskDetail? = nil
    
    @IBOutlet var displayLabel: UILabel!
    @IBOutlet var timeButtons: [UIButton]!
    
	// Listener to the buttons
    @IBAction func onTap(_ sender: UIButton) {
        let offset = calculateOffset()
        
        let idx = (12+(sender.tag - offset))%12
        currentIndex = idx
        
		populateCollectionView(idx)
        
        var count = 0
        for arr in clockTasks{
            for _ in arr {
                count+=1
            }
        }
        print("Number of elements is " + String(count))
        
    }
    
	// Listener used when detail page is poped
	@objc func onTapWhileDetailDisplayed(_ sender: UITapGestureRecognizer) {
		// Retrieve the detail view
		let detailView = self.view.subviews.last!
		// Determine the tapping location
		let location = sender.location(in: detailView)
		// If tapped outside the detail view
		if !detailView.point(inside: location, with: nil) {
			// Dismiss the detail view with animation
			let animator = UIViewPropertyAnimator(duration: 0.1, curve: .easeOut, animations: UITaskDetail.dimiss(detailView as! UITaskDetail))
			animator.addCompletion({_ in
				self.view.subviews.last!.removeFromSuperview()
				self.deTransparentizeBackground()
				// Put clock hands back
				self.addHandsAndCenterPiece()
				// Remove the gesture recognizer
				_ = self.view.gestureRecognizers!.popLast()
				// Remove detail page variable
				self.taskDetail = nil
			})
			animator.startAnimation()
		}
	}
	
	// Event handler to task editing when cog is clicked
	@objc func onCogTap(_ sender: UIButton) {
		// Create an animation for Task Editing page.
		// Cog rotating animation stops in 0.5 sec, so Task Editing page should not take over until .5 sec.
		DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(300)), execute: {
			let taskEditVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskEditPageViewController") as! TaskEditPageViewController
			taskEditVC.isEditMode = true
			taskEditVC.taskToEdit = (self.view.subviews.last! as! UITaskDetail).task!
			let taskEditNC: UINavigationController = UINavigationController(rootViewController: taskEditVC)
			self.present(taskEditNC, animated: true, completion: nil)
		})
	}
    
    //Regular clock functions start here
    //DO NOT TOUCH
    @IBOutlet var myClock: ClockFaceView!
    var containerView: UIView!
    
	var count = 0
	var viewName = "Clock View"

    //When app first loads
	override func viewDidLoad() {
		super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        changeTheme()
        //Sets background color based on theme from settings
        //self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
        //myClock.drawOuterFrame()

        let startAngle = .pi / 12.0
        let angle = .pi / 6.0
        for index in 0...11 {
            timeButtons[index].transform = CGAffineTransform(rotationAngle: CGFloat((Double(index)*angle)+startAngle));
        }
        
        //Sets button labels as number of tasks within that hour
        for i in 0...11 {
            timeButtons[i].setTitle(String(clockTasks[i].count), for: .normal)
        }
	}
	
    override func viewDidLayoutSubviews() {
		if self.taskDetail == nil && self.containerView == nil {
        	self.removeContainerView()
        	self.addHandsAndCenterPiece()
		}
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    //Whenever clockview shows up in general
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
        
        changeTheme()
		self.myClock.setNeedsDisplay()
        //Sets background color based on theme from settings
        //self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
        //myClock.drawOuterFrame()
		
		TaskManager.sharedTaskManager.refreshTaskManager()

        self.removeContainerView()
        self.addHandsAndCenterPiece()
        
        for i in 0...11 {
            clockTasks[i].removeAll()
        }
        
        //Tasks sort every time page is viewed
        TaskManager.sharedTaskManager.sortTasks(by: .time)
        let currTasks = TaskManager.sharedTaskManager.getTasks()
        
        //Current system time
        var sysTime = Int32(Date().timeIntervalSince1970)
        sysTime = sysTime - (sysTime%3600)
        
        for curr in currTasks {
            let startTime = curr.getScheduleStart()
            let endTime = curr.getScheduleStart() + curr.getDuration()
            //If beyond 12 hours, return
            if startTime >= sysTime+(12*3600) {
                break
			} else if startTime == 0 {
				// Not scheduled yet. To avoid runtime error.
				break
			}
            
            //at this point, task is within 12 hours
            //Start index
			//set it to 0 to ignore the part before current time to avoid error.
			let startIdx = (startTime >= sysTime) ? ((startTime-sysTime)/3600) : 0
            //clockTasks[Int(startIdx)].append(curr)
            
            //End index
            let endIdx = (endTime-1-sysTime)/3600
            for i in startIdx...endIdx {
                if i > 11 {
                    break
                }
                clockTasks[Int(i)].append(curr)
            }
            
        }
        //Sets button title as number of tasks within that hour
        let offset = calculateOffset()
        
        for j in 0...11 {
            let index = (j+offset)%12
            let noOfTasks = clockTasks[j].count
            
            timeButtons[index].setTitle(String(noOfTasks), for: .normal)
            
            //Puts a bubble behind text if there are more than 1 tasks in interval
            if noOfTasks > 0 {
                timeButtons[index].setBackgroundImage(#imageLiteral(resourceName: "greyemptybubble"), for: .normal)
                timeButtons[index].tintColor = UIColor.white
            } else {
                timeButtons[index].setBackgroundImage(nil, for: .normal)
                timeButtons[index].tintColor = UIColor.clear
            }
        }
     
        /*for i in 0...11 {
            for task in clockTasks[i] {
                print(task.getTitle())
            }
            print("end")
        }*/
		
		if currentIndex != nil {
			self.populateCollectionView(currentIndex!)
		}
		DispatchQueue.main.async {
			self.changeTheme()
		}
		
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		// Dismiss detail page
		if type(of: self.view.subviews.last!) == UITaskDetail.self {
			self.view.subviews.last!.removeFromSuperview()
			_ = self.view.gestureRecognizers?.popLast()
            self.deTransparentizeBackground()
		}
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
        
        //Sets background color based on theme from settings
        //self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
        //myClock.drawOuterFrame()
        
		// Prompt past tasks alerts
		TaskManager.sharedTaskManager.promptNextAlert(self)
	}
    
    func addHandsAndCenterPiece() {
        containerView = UIView(frame: CGRect(x: myClock.frame.midX, y: myClock.frame.midY, width: myClock.frame.width/4, height: myClock.frame.width/4))
        
        containerView.tag = 10
        self.view.addSubview(containerView)
        
        // hour hand
        let hourHandWidth:CGFloat = (myClock.bounds.height/2 * 0.030)
        // minute hand
        let minuteHandWidth:CGFloat = (myClock.bounds.height/2 * 0.0225)
        // second hand
        let secondHandWidth:CGFloat = (myClock.bounds.height/2 * 0.0168)
        
        let time = timeCoords(myClock.bounds.minX, y: myClock.bounds.minY, time: ctime(),radius: myClock.bounds.height/2)
        
        let hourHandPath = UIBezierPath()
        let minuteHandPath = UIBezierPath()
        let secondHandPath = UIBezierPath()
        
        hourHandPath.move(to: CGPoint(x: containerView.bounds.minX, y:containerView.bounds.minY ))
        minuteHandPath.move(to: CGPoint(x: containerView.bounds.minX, y:containerView.bounds.minY ))
        secondHandPath.move(to: CGPoint(x: containerView.bounds.minX, y:containerView.bounds.minY ))
        
        hourHandPath.addLine(to: CGPoint(x: time.h.x/1.5, y: time.h.y/1.5))
        hourHandPath.lineWidth = hourHandWidth
        let hourLayer = CAShapeLayer()
        hourLayer.path = hourHandPath.cgPath
        hourLayer.lineWidth = hourHandWidth
        hourLayer.lineCap = kCALineCapButt
        hourLayer.strokeColor = UIColor.black.cgColor
        hourLayer.rasterizationScale = UIScreen.main.scale;
        hourLayer.shouldRasterize = true
        containerView.layer.addSublayer(hourLayer)
        rotateLayer(hourLayer,dur:43200)
        
        minuteHandPath.addLine(to: CGPoint(x: time.m.x, y: time.m.y))
        minuteHandPath.lineWidth = minuteHandWidth
        let minuteLayer = CAShapeLayer()
        minuteLayer.path = minuteHandPath.cgPath
        minuteLayer.lineWidth = minuteHandWidth
        minuteLayer.lineCap = kCALineCapButt
        minuteLayer.strokeColor = UIColor.black.cgColor
        minuteLayer.rasterizationScale = UIScreen.main.scale;
        minuteLayer.shouldRasterize = true
        containerView.layer.addSublayer(minuteLayer)
        rotateLayer(minuteLayer,dur: 3600)
        
        secondHandPath.addLine(to: CGPoint(x: time.s.x, y: time.s.y))
        secondHandPath.lineWidth = secondHandWidth
        let secondLayer = CAShapeLayer()
        secondLayer.path = secondHandPath.cgPath
        secondLayer.lineWidth = secondHandWidth
        secondLayer.lineCap = kCALineCapButt
        secondLayer.strokeColor = UIColor.red.cgColor
        secondLayer.rasterizationScale = UIScreen.main.scale;
        secondLayer.shouldRasterize = true
        containerView.layer.addSublayer(secondLayer)
        rotateLayer(secondLayer,dur: 60)
        
        let endAngle = CGFloat(2) * .pi
        let circle = UIBezierPath(arcCenter: CGPoint(x: containerView.bounds.origin.x, y:containerView.bounds.origin.y), radius: myClock.bounds.height/2 * 0.03, startAngle: 0, endAngle: endAngle, clockwise: true)
        let centerPiece = CAShapeLayer()
        
        centerPiece.path = circle.cgPath
        centerPiece.fillColor = UIColor.black.cgColor
        containerView.layer.addSublayer(centerPiece)
    }
    
    func rotateLayer(_ currentLayer:CALayer,dur:CFTimeInterval){
        let angle = degree2radian(360)
        
        let animation = CABasicAnimation(keyPath:"transform.rotation.z")
        animation.duration = dur
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        animation.fromValue = 0
        animation.repeatCount = Float.infinity
        animation.toValue = angle
        // Add animation to layer
        currentLayer.add(animation, forKey:"rotate")
    }
    
    func timeCoords(_ x:CGFloat,y:CGFloat,time:(h:Int,m:Int,s:Int),radius:CGFloat,adjustment:CGFloat=90)->(h:CGPoint, m:CGPoint,s:CGPoint) {
        let cx = x
        let cy = y
        var r  = radius * 0.52
        var points = [CGPoint]()
        var angle = degree2radian(6)
        func newPoint (_ t:Int) {
            let xpo = cx - r * cos(angle * CGFloat(t)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(t)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
        }
        // hours
        var hours = time.h
        if hours > 12 {
            hours = hours-12
        }
        let hoursInSeconds = time.h*3600 + time.m*60 + time.s
        newPoint(hoursInSeconds*5/3600)
        
        // minutes
        r = radius * 0.58
        let minutesInSeconds = time.m*60 + time.s
        newPoint(minutesInSeconds/60)
        
        // seconds
        r = radius * 0.63
        newPoint(time.s)
        
        return (h:points[0],m:points[1],s:points[2])
    }
	
    func degree2radian(_ a:CGFloat)->CGFloat {
        let b = .pi * a / 180.0
        return b
    }
	
    func ctime ()->(h:Int,m:Int,s:Int) {
        var t = time_t()
        time(&t)
        let x = localtime(&t)
        
        return (h:Int(x!.pointee.tm_hour),m:Int(x!.pointee.tm_min),s:Int(x!.pointee.tm_sec))
    }
    
    @objc func applicationDidBecomeActive() {
        self.removeContainerView()
    }
	
    @objc func applicationDidEnterBackground() {
        self.removeContainerView()
    }
	
    func removeContainerView() {
        if (containerView != nil) {
            containerView.removeFromSuperview()
			containerView = nil
        }
    }
    
    func calculateOffset() -> Int {
        //Calculates offset based on current system time
        var offset = Int(Date().timeIntervalSince1970)
        offset = offset - (offset%3600)
        let cal = Calendar.current
        let startOfDay = cal.startOfDay(for: Date())
        offset = offset - Int(startOfDay.timeIntervalSince1970)
        offset = (offset / 3600) % 12
        
        return offset
    }
    
    //Changes backgrounds based on theme in settings
    func changeTheme() {
        self.view.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
        self.displayLabel.backgroundColor = TaskManager.sharedTaskManager.getTheme().collectionBackground
        myClock.drawOuterFrame()
    }
	
	// Change opacity when detail page shows.
	func transparentizeBackground() {
		for subview in self.view.subviews {
			subview.alpha = 0.3
		}
		self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(0.3)
	}
	
	// Change opacity when detail page goes away.
	func deTransparentizeBackground() {
		for subview in self.view.subviews {
            if subview == displayLabel {
                subview.alpha = 0.8
            } else {
                subview.alpha = 1
            }
		}
		self.view.backgroundColor = self.view.backgroundColor?.withAlphaComponent(1)
	}
	
	private func populateCollectionView(_ idx: Int) {
		//Collection view declaration
		if taskCollection != nil {
			taskCollection.removeFromSuperview()
		}
		
		//Displays ContainerView iff tasks exist between interval
		if clockTasks[idx].count == 0 {
			displayLabel.text = "No tasks between this hour!"
			displayLabel.textColor = TaskManager.sharedTaskManager.getTheme().tableBackground
            displayLabel.backgroundColor = TaskManager.sharedTaskManager.getTheme().collectionBackground
		} else {
			//Layout setup
			let padding = CGFloat(10.0)
			let layout = UICollectionViewFlowLayout()
			layout.scrollDirection = .vertical
			layout.minimumLineSpacing = padding
			layout.minimumInteritemSpacing = padding
			layout.itemSize = CGSize(width: ((displayLabel.frame.width-padding)-(3*padding))/2, height: ((displayLabel.frame.height-padding)-(3*padding))/2)
			let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
			layout.sectionInset = insets
			
			taskCollection = UICollectionView(frame: displayLabel.frame, collectionViewLayout: layout)
			taskCollection.register(ClockTaskCell.self, forCellWithReuseIdentifier: "clockTaskCell")
			taskCollection.dataSource = self
			taskCollection.delegate = self
			
			//taskCollection.backgroundColor = TaskManager.sharedTaskManager.getTheme().collectionBackground //Needs to be color coded by category
			taskCollection.backgroundColor = UIColor.clear
            displayLabel.text = ""
            displayLabel.backgroundColor = TaskManager.sharedTaskManager.getTheme().collectionBackground
            
			self.view.addSubview(taskCollection)
			taskCollection.anchor(top: nil, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: displayLabel.frame.width - 10, height: displayLabel.frame.height - 10, centerX: displayLabel.centerXAnchor, centerY: displayLabel.centerYAnchor)
		}
	}
}
