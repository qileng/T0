//
//  MainDetailTableViewCell.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/26/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class MainDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var eventTimeLabel1: UILabel!
    @IBOutlet weak var eventTimeLabel2: UILabel!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    @IBOutlet weak var halpSuggestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
