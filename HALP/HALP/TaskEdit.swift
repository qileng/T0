//
//  EditTask.swift
//  HALP
//
//  Created by FlikHu on 5/14/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit


class TaskEditViewController: UIViewController {
    
    // This function handles everything that needs to be set up once for this UI.
    // This function is called only after the UIViewController is loaded and never again.
    
    @IBOutlet weak var taskTitle: UITextField!
    @IBOutlet weak var taskDeadline: UITextField!
    @IBOutlet weak var DatePicker: UIDatePicker!
    private var date: Date!
    
    @IBAction func Cancel(_ sender: Any) {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
    }
    
    @IBAction func Confirm(_ sender: Any) {
        
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
    }
    
    @IBAction func pickDeadline(_ sender: Any) {
        DatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        date = DatePicker.date
        print(date)
    }
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // This function I haven't figure out any significant usage yet.         --Qihao
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // This function handles everything that needs to be set up everytime for this UI.
    // This function is called after each time the UIViewController is brought to front.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
