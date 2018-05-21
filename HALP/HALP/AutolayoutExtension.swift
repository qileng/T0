//
//  AutolayoutExtension.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/12/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//
import UIKit
import Foundation


class LeftPaddedTextField: UITextField {
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    
}
extension UIColor
{
    static func rgbColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor
    {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }

}

extension UIStackView
{
    func addArrangedSubViews(_ views:[UIView])
    {
        views.forEach { (view) in
            self.addArrangedSubview(view)
        }
    }
}

extension UIView
{
    func addSubviews(_ views:[UIView])
    {
        views.forEach { (view) in
            self.addSubview(view)
        }
    }
}


extension UIView
{
    func anchor(top:NSLayoutYAxisAnchor?,
                left:NSLayoutXAxisAnchor?,
                right:NSLayoutXAxisAnchor?,
                bottom:NSLayoutYAxisAnchor?,
                topConstant:CGFloat,
                leftConstant:CGFloat,
                rightConstant:CGFloat,
                bottomConstant:CGFloat,
                width:CGFloat,
                height:CGFloat,
                centerX:NSLayoutXAxisAnchor?,
                centerY:NSLayoutYAxisAnchor?)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top
        {
            self.topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        }
        if let left = left
        {
            self.leftAnchor.constraint(equalTo: left, constant: leftConstant).isActive = true
        }
        if let right = right
        {
            self.rightAnchor.constraint(equalTo: right, constant: -rightConstant).isActive = true
        }
        if let bottom = bottom
        {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant).isActive = true
        }
        
        if width > 0
        {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height > 0
        {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        if let centerX = centerX
        {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        if let centerY = centerY
        {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }
}
