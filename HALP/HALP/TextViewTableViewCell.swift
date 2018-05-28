//
//  TextViewTableViewCell.swift
//  HALP
//
//  Created by Dong Yoon Han on 5/22/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {

    var valueChanged: (() -> Void)?

    @IBOutlet weak var textViewOutlet: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textViewOutlet.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Description"
        {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 15)
        }else
        {
            textView.textColor = .black
            textView.font = UIFont.systemFont(ofSize: 15)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""
        {
            textView.text = "Description"
            textView.textColor = .lightGray
            textView.font = UIFont.systemFont(ofSize: 17)
        }
    }

}
