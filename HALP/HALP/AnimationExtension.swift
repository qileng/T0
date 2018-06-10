//
// Created by Qihao Leng on 5/16/18.
// Copyright (c) 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

extension UIButton {
	@objc func rotate(_ sender: UIButton) {
		let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .linear, animations: {self.imageView!.transform = self.imageView!.transform.rotated(by: .pi / 2.0)})
		animator.startAnimation()
	}
}

class UIBar: UILabel {
	var size = 0.0 as CGFloat
	
	func grow() {
		if size == 0 {
			return
		} else {
			self.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(size) / 2)
		}
	}
	
	func shrink() {
		self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: -2)
	}
}


class UIBarLabel: UILabel {
	var height = 0.0 as CGFloat
	
	func move() {
		self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.origin.y - height), size: self.frame.size)
	}
}
