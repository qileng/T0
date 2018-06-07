//
//  UICircularGradientSector.swift
//  HALP
//
//  Created by Qihao Leng on 6/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class UICircularGradientSector: UIView {
	let partition: Int
	let index: Int
	let innerIndex: Int
	//let gradient: UIColor
	
	init(frame: CGRect, partition: Int, index: Int, innerIndex: Int) {
		self.partition = partition
		self.index = index
		self.innerIndex = innerIndex
		super.init(frame: frame)
		print("Sector frame: ", self.frame)
		print("Bounds: ", self.bounds)
		self.backgroundColor = .clear
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func drawSector() {
		let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
		let radius: CGFloat = (max(bounds.width, CGFloat(Int(bounds.height))) / 2) - 10
		//let radius: CGFloat = (bounds.width/2 * 0.6) - 5
		let arcWidth: CGFloat = 0
		let startAngle: CGFloat = 0
		let endAngle: CGFloat = π/6 / CGFloat(partition)
		// Calculate current hour
		let current = Calendar.current.component(.hour, from: Date()) % 12
		print("Current Hour: ", current)
		let offset = current - 3	// Seems like 0 degree is pointing EAST
		
		let path = UIBezierPath()
		path.move(to: center)
		let indexPath = (index+offset) * partition + innerIndex
		path.addArc(withCenter: center, radius: radius-(CGFloat(Int(bounds.height)) * 0.083), startAngle: (startAngle+(CGFloat(indexPath)*endAngle)), endAngle: (endAngle+(CGFloat(indexPath)*endAngle)), clockwise: true)
		path.close()
		
		let hex = TaskManager.sharedTaskManager.getTheme().tableBackground.getHex()
		// Calculate darkened color. Need to preserve RGB ratio.
		// Darken to at most 50%. So divide the color space into 24 instead of 12.
		var r = (hex & 0xff0000) >> 16
		var g = (hex & 0x00ff00) >> 8
		var b = (hex & 0x0000ff)
		print("rgb: ", String(r, radix:16),String(g, radix:16),String(b, radix:16))
		let colorPartition = partition * 24
		r = r * (colorPartition - index*partition - innerIndex) / colorPartition
		g = g * (colorPartition - index*partition - innerIndex) / colorPartition
		b = b * (colorPartition - index*partition - innerIndex) / colorPartition
		print("Darkened to: ", String(r, radix: 16), String(g, radix: 16), String(b, radix: 16))
		let result = r << 16 + g << 8 + b
		print("which is: ", String(result, radix: 16))
		let darkenedColor = UIColor(hex: result)
		path.lineWidth = arcWidth
		darkenedColor.setStroke()
		path.lineWidth = (bounds.height * 0.01)
		path.stroke()
		darkenedColor.setFill()
		path.fill()
	}
	
	override func draw(_ rect: CGRect) {
		//drawInnerFrame()
		drawSector()
	}
}
