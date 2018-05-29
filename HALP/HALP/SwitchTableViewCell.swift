//
//  SwitchTableViewCell.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/27/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var switchOutlet: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    var valueChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        switchOutlet.isOn = UserDefaults.standard.bool(forKey: StartTimeModeKey)
        switchOutlet.tintColor = taskColorTheme
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        print(sender.isOn)
        valueChanged?()
    }
    
}
