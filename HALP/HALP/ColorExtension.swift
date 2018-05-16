//
//  ColorExtension.swift
//  HALP
//
//  Created by Qihao Leng on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIColor {
	convenience init (hex: Int) {
		let red = hex & 0xff0000
		let green = hex & 0x00ff00
		let blue = hex & 0x0000ff
		
		let CGred = CGFloat(red >> 16) / 255.0
		let CGgreen = CGFloat(green >> 8) / 255.0
		let CGblue = CGFloat(blue) / 255.0
		
		self.init(red: CGred, green: CGgreen, blue: CGblue, alpha: CGFloat(1.0))
	}
}


class ColorTheme {
	var text: UIColor
	var task: UIColor
	var taskBackground: UIColor
	var background: UIColor
	
	init(text: Int, task: Int, taskBackground: Int, background: Int) {
		self.text = UIColor(hex: text)
		self.taskBackground = UIColor(hex: taskBackground)
		self.background = UIColor(hex: background)
		self.task = UIColor(hex: task)
	}
	
	static let regular = ColorTheme(text: 0x0, task: 0x00b0ff, taskBackground: 0xf8de7e, background: 0xffffffff)
	static let dark = ColorTheme(text:0x0, task: 0x176a90, taskBackground: 0xffffffff, background: 0x0)
}

enum Theme: Int {
	case regular = 0
	case dark = 1
}

