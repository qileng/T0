//
//  ClockTaskCell.swift
//  HALP
//
//  Created by Anagha Subramanian on 5/27/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation
import UIKit

class ClockTaskCell: UICollectionViewCell {
    
    var taskImage: UIImageView!
    var taskName: UILabel!
    
    override init(frame: CGRect) {
        taskName = UILabel()
        
        super.init(frame: frame)
        //self.backgroundColor = UIColor(hex: 0x59262f)
        self.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "browns-1"))
        self.layer.cornerRadius = 30
        //Experiment shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true

    }
    
    func displayContent(task:Task) {
        switch task.getCategory() {
        case .Study_Work:
            taskImage = UIImageView(image: #imageLiteral(resourceName: "study"))
        case .Entertainment:
            taskImage = UIImageView(image: #imageLiteral(resourceName: "entertainment"))
        case .Chore:
            taskImage = UIImageView(image: #imageLiteral(resourceName: "chore"))
        case .Relationship:
            taskImage = UIImageView(image: #imageLiteral(resourceName: "relationship"))
        }
        taskImage.image = taskImage.image!.withRenderingMode(.alwaysTemplate)
        taskImage.tintColor = UIColor.white
        //taskName = UILabel()
        taskName.text = task.getTitle()
        self.addSubview(taskImage)
        taskImage.anchor(top: nil, left: nil, right: nil, bottom: self.centerYAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: frame.width/2, height: frame.width/2, centerX: self.centerXAnchor, centerY: nil)
        self.addSubview(taskName)
        taskName.anchor(top: taskImage.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: frame.width, height: frame.width/2, centerX: self.centerXAnchor, centerY: nil)
        taskName.textColor = UIColor.white
        //let size = CGSize(width: frame.width/2, height: frame.height/2)
        //super.init(frame: CGRect(origin: frame.origin, size: size))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
