//
//  UIClockBackground.swift
//  HALP
//
//  Created by Qihao Leng on 6/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


class UIClockBackground: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func drawOuterFrame() {
		let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
		print("RightCenter: ", center)
		let radius: CGFloat = (max(bounds.width, bounds.height) / 2) - 5
		let arcWidth: CGFloat = 0
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = π/6
		
		//Draws sectors behind clock
		for index in 0...11 {
			let path = UIBezierPath()
			path.move(to: center)
			path.addArc(withCenter: center, radius: radius, startAngle: (startAngle+(CGFloat(index)*endAngle)), endAngle: (endAngle+(CGFloat(index)*endAngle)), clockwise: true)
			path.close()
			
			let strokeColor: UIColor = UIColor.white
			path.lineWidth = arcWidth
			strokeColor.setStroke()
			path.lineWidth = (bounds.height * 0.01)
			path.stroke()
			
			let fillColor: UIColor
			fillColor = TaskManager.sharedTaskManager.getTheme().clockBackground
			fillColor.setFill()
			path.fill()
		}
	}
	
	func drawFrame() {
		let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
		let radius: CGFloat = (max(bounds.width, bounds.height) / 2) - 10
		let arcWidth: CGFloat = 0
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = 2*π
		
		let path = UIBezierPath(arcCenter: center, radius: radius-(bounds.height * 0.083),startAngle: startAngle, endAngle: endAngle, clockwise: true)
		
		let strokeColor: UIColor = UIColor.clear
		path.lineWidth = arcWidth
		strokeColor.setStroke()
		path.lineWidth = (bounds.height * 0.01)
		path.stroke()
		
		let fillColor: UIColor = UIColor.white
		fillColor.setFill()
		path.fill()
	}
	
	override func draw(_ rect: CGRect) {
		drawOuterFrame()
		drawFrame()
	}
}

