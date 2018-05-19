//
//  SettingPage.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit


class SettingViewController: UIViewController {
	
	@IBOutlet weak var ViewLabel: UILabel!
	
	var count = 0
	var viewName = "Setting Page"
    var settingForm: SettingForm?
    
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		count += 1
		self.ViewLabel!.text = viewName + " appeared \(count) time" + ((count == 1) ? "" : "s")
        //Create a settingForm object
        settingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
	}
    
    @IBAction func Logout(_ sender: Any) {
        let loginVC:StartupViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
        let loginSignUpNC: UINavigationController = UINavigationController(rootViewController: loginVC)
        self.present(loginSignUpNC, animated: true, completion: nil)
    }
    
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        settingForm?.toggleNotification()
    }
    
    @IBAction func defaultViewSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Clock View
            settingForm?.setDefaultView(View(rawValue: 0)!)
        } else if (sender.selectedSegmentIndex == 1) {
            //Switch to List View
            settingForm?.setDefaultView(View(rawValue: 1)!)
        }
    }
    
    
}

