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
        switchOutlet.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        switchOutlet.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: StartTimeModeKey)
        valueChanged?()
    }
}
