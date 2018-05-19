//
//  Clockview.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class ClockViewController: UIViewController, CAAnimationDelegate {
	
//    @IBOutlet weak var ViewLabel: UILabel!
    @IBOutlet var myClock: ClockFaceView!
    var containerView: UIView!
    
	var count = 0
	var viewName = "Clock View"

	override func viewDidLoad() {
		super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

	}
    override func viewDidLayoutSubviews() {
//         self.removeContainerView()
//        self.addHandsAndCenterPiece()
    }
    
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
//        count += 1
//        self.ViewLabel!.text = viewName + " appeared \(count) time" + ((count == 1) ? "" : "s")
        self.removeContainerView()
        self.addHandsAndCenterPiece()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

	}
    
    
    
    
    func addHandsAndCenterPiece() {
        containerView = UIView(frame: CGRect(x: myClock.frame.midX, y: myClock.frame.midY, width: myClock.frame.width, height: myClock.frame.width))
        
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
        
        hourHandPath.addLine(to: CGPoint(x: time.h.x, y: time.h.y))
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
        minuteLayer.strokeColor = UIColor.gray.cgColor
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
        
        let endAngle = CGFloat(2*Double.pi)
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
        let b = CGFloat(Double.pi) * a/180
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
        }
    }
}
