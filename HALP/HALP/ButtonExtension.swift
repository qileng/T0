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
