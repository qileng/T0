//
//  UICircularGradientView.swift
//  HALP
//
//  Created by Qihao Leng on 6/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class UICircularGradientView: UIView {
	
	func drawInnerFrame() {
		let center = CGPoint(x:bounds.width/2, y: bounds.height/2)
		let radius: CGFloat = (max(bounds.width, bounds.height) / 2) - 10
		let arcWidth: CGFloat = 0
		let startAngle: CGFloat = 0
		let partition: Int = 10
		let endAngle: CGFloat = π/6 / CGFloat(partition)
		//Calculate current hour
		let current = Calendar.current.component(.hour, from: Date()) % 12
		print("Current Hour: ", current)
		let offset = current - 3 	 //Seems like 0 degree is pointing EAST
		
		// Draws sectors behind clock
		for index in 0...11 {
			for i in 0...(Int(partition-1)) {
				let path = UIBezierPath()
				path.move(to: center)
				let indexPath = (index+offset) * partition + i
				path.addArc(withCenter: center, radius: radius-(bounds.height * 0.083), startAngle: (startAngle+(CGFloat(indexPath)*endAngle)), endAngle: (endAngle+(CGFloat(indexPath)*endAngle)), clockwise: true)
				path.close()
				
				let hex = TaskManager.sharedTaskManager.getTheme().tableBackground.getHex()
//				Calculate darkened color. Need to preserve RGB ratio.
//				Darken to at most 50%. So divide the color space into 24 instead of 12.
				var r = (hex & 0xff0000) >> 16
				var g = (hex & 0x00ff00) >> 8
				var b = (hex & 0x0000ff)
				print("rgb: ", String(r, radix:16),String(g, radix:16),String(b, radix:16))
				let colorPartition = partition * 24
				r = r * (colorPartition - index*partition - i) / colorPartition
				g = g * (colorPartition - index*partition - i) / colorPartition
				b = b * (colorPartition - index*partition - i) / colorPartition
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
		}
	}
	
	override func draw(_ rect: CGRect) {
		drawInnerFrame()
	}
}
