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
        
        let f = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width / 2 , height: frame.height / 2)
        super.init(frame: f)
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
        //taskName = UILabel()
        taskName.text = task.getTitle()
        self.addSubview(taskImage)
        taskImage.anchor(top: nil, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: frame.width, height: frame.height, centerX: self.centerXAnchor, centerY: self.centerYAnchor)
        self.addSubview(taskName)
        taskName.anchor(top: taskImage.bottomAnchor, left: nil, right: nil, bottom: nil, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: frame.width, height: frame.height, centerX: self.centerXAnchor, centerY: nil)
        print(taskName.text)
        //let size = CGSize(width: frame.width/2, height: frame.height/2)
        //super.init(frame: CGRect(origin: frame.origin, size: size))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
