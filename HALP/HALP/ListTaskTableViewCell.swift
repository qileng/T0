//
//  ListTaskTableViewCell.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/19/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

//identifier : "taskListCell"
class ListTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//            self.backgroundColor = UIColor.rgbColor(0, 122, 255)
        self.backgroundColor = TaskManager.sharedTaskManager.getTheme().tableBackground
//        self.titleLabel.textColor = TaskManager.sharedTaskManager.getTheme().background
//        self.detailLabel.textColor = UIColor.HalpColors.caputMortuum
        self.taskImageView.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
