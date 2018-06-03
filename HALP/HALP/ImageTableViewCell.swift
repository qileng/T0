//
//  ImageTableViewCell.swift
//  HALP
//
//  Created by Dong Yoon Han on 6/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabelOutlet: UILabel!
    @IBOutlet weak var imageViewOutlet: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
