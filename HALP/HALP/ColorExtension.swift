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
    
    convenience init (hex: Int, alpha: CGFloat) {
        let red = hex & 0xff0000
        let green = hex & 0x00ff00
        let blue = hex & 0x0000ff
        
        let CGred = CGFloat(red >> 16) / 255.0
        let CGgreen = CGFloat(green >> 8) / 255.0
        let CGblue = CGFloat(blue) / 255.0
        
        self.init(red: CGred, green: CGgreen, blue: CGblue, alpha: alpha)
    }
    
    struct HalpColors {
        //rgb(255,90,95)
        static let pastelRed = UIColor.rgbColor(255, 90, 95)
        //rgb(211,106,99)
        static let fuzzyWuzzy = UIColor.rgbColor(211, 106, 99)
        //rgb(89,38,47)
        static let caputMortuum = UIColor.rgbColor(89, 38, 47)
        //rgb(206,137,100)
        static let paleCopper = UIColor.rgbColor(206, 137, 100)
        //blue colors
        //rgb(53,142,252)
        static let brilliantAzure = UIColor.rgbColor(53, 142, 252)
        //brown for the icons in task views
        static let woodBrown = UIColor(hex: 0x745f4f)
		//yellow for the icons
		static let goldPineYellow = UIColor(hex: 0xe4ad4e)
		//ligh grey for table background
		static let lightGrey = UIColor(hex: 0xf2f2f2)
    }
}


class ColorTheme {
	var tableBackground: UIColor
	var background: UIColor
    var clockBackground: UIColor        //New variable to set clock background
	var collectionBackground: UIColor
	var imgTint: UIColor
	
	init(tableBackground: UIColor, background: UIColor, clockBackground: UIColor, collectionBackground: UIColor, imgTint: UIColor) {
		self.tableBackground = tableBackground
		self.background = background
        self.clockBackground = clockBackground
		self.collectionBackground = collectionBackground
		self.imgTint = imgTint
	}
	
	static let regular = ColorTheme(tableBackground: UIColor.HalpColors.lightGrey, background: UIColor(patternImage: #imageLiteral(resourceName: "goldpine")), clockBackground: UIColor(patternImage: #imageLiteral(resourceName: "daySky")), collectionBackground: UIColor(hex: 0xce8964), imgTint: UIColor.HalpColors.goldPineYellow)
	static let dark = ColorTheme(tableBackground: UIColor.HalpColors.lightGrey, background: UIColor(patternImage: #imageLiteral(resourceName: "wooder")), clockBackground: UIColor(patternImage: #imageLiteral(resourceName: "space2")), collectionBackground: UIColor(hex: 0xce8964), imgTint: UIColor.HalpColors.woodBrown)
	
	//TODO: Add more themes
}

//Sets regular or dark themes based on enum 1 or 0 values for accessibility
enum Theme: Int {
	case regular = 0
	case dark = 1
}

