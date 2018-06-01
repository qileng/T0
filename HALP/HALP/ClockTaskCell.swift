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
        super.init(frame: frame)
        self.backgroundColor = TaskManager.sharedTaskManager.getTheme().task
        self.layer.cornerRadius = 30
        //self.clipsToBounds = true
        
        //Experiment shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 10
        self.layer.shouldRasterize = true
    }
    
    func displayContent(task:Task) {
		// Set up Icon
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
        taskImage.tintColor = TaskManager.sharedTaskManager.getTheme().text
		
		// Set up Title
		taskName = UILabel()
		taskName.textColor = TaskManager.sharedTaskManager.getTheme().text
        taskName.text = task.getTitle()
		taskName.textAlignment = .center
		
		// Set up cell layout
        self.addSubview(taskImage)
		self.addSubview(taskName)
        taskImage.anchor(top: nil, left: nil, right: nil, bottom: self.centerYAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: frame.width/2, height: frame.width/2, centerX: self.centerXAnchor, centerY: nil)
        taskName.anchor(top: taskImage.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: frame.width, height: frame.width/2, centerX: self.centerXAnchor, centerY: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
