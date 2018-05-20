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
    
    @IBAction func defaultSortingMethodSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Time based sorting
            settingForm?.setDefaultSort(SortingType(rawValue: 0)!)
            print(settingForm?.getDefaultSort().rawValue)
        } else if (sender.selectedSegmentIndex == 1) {
            //Switch to Prority based sorting
            settingForm?.setDefaultSort(SortingType(rawValue: 1)!)
            print(settingForm?.getDefaultSort().rawValue)
        }
    }
    
    @IBAction func themeSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Light Theme
            settingForm?.setTheme(Theme(rawValue: 0)!)
            print(settingForm?.getTheme().rawValue)
        } else if (sender.selectedSegmentIndex == 1){
            //Switch to Dark Theme
            settingForm?.setTheme(Theme(rawValue: 1)!)
            print(settingForm?.getTheme().rawValue)
        }
    }
    
    //Seven toggles
    @IBAction func sunSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<0)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b1111110)
        }
    }
    
    @IBAction func monSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<1)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b1111101)
        }
    }
    
    @IBAction func tueSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<2)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b1111011)
        }
    }
    
    @IBAction func wedSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<3)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b1110111)
        }
    }
    
    @IBAction func thuSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<4)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b1101111)
        }
    }
    
    @IBAction func friSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<5)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b1011111)
        }
    }
    
    @IBAction func satSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! | 1<<6)
        } else {
            settingForm?.setAvailableDays((settingForm?.getAvailableDays())! & 0b0111111)
        }
        print(settingForm?.getAvailableDays())
    }
    
}

