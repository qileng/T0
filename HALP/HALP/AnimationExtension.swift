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
		//self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: -100)
		if size == 0 {
			return
		} else {
			self.transform = CGAffineTransform(scaleX: 1.0, y: CGFloat(size) / 2)
		}
		//self.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.0, 50.0, 1.1)
	}
	
	func shrink() {
		//self.transform = CGAffineTransform(scaleX: 1.0, y: 0.02)
		self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: -2)
	}
}


class UIBarLabel: UILabel {
	var height = 0.0 as CGFloat
	
	func move() {
		self.frame = CGRect(origin: CGPoint(x: self.frame.origin.x, y: self.frame.origin.y - height), size: self.frame.size)
	}
}
