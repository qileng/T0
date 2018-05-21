//
//  TextFieldTableViewCell.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/21/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textFieldOutlet: LeftPaddedTextField!
    
    var valueChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textFieldOutlet.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.textFieldOutlet.resignFirstResponder()
        valueChanged?()
        //can put value changed action
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldOutlet.resignFirstResponder()
        return true
    }
    
    func shakeTitleInput()
    {
        UIView.animate(withDuration: 0.05, animations: { self.textFieldOutlet.frame.origin.x -= 5 }, completion: { _ in
            UIView.animate(withDuration: 0.05, animations: { self.textFieldOutlet.frame.origin.x += 10 }, completion: { _ in
                UIView.animate(withDuration: 0.05, animations: { self.textFieldOutlet.frame.origin.x -= 10 }, completion: { _ in
                    UIView.animate(withDuration: 0.05, animations: { self.textFieldOutlet.frame.origin.x += 10 }, completion: { _ in
                        UIView.animate(withDuration: 0.05, animations: { self.textFieldOutlet.frame.origin.x -= 5 })
                    })
                })
            })
        })
    }
    

}
