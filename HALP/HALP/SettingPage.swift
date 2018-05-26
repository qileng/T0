//
//  SettingPage.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit



class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
	var viewName = "Setting Page"
    var settingForm: SettingForm?
    

    //Could have: Loop the data
    @IBOutlet weak var startTimePicker: UIPickerView!
    @IBOutlet weak var endTimePicker: UIPickerView!
    let startHoursArray: Array<Int32> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    let endHoursArray: Array<Int32> = [24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
    
    @IBOutlet weak var startTimeNum: UILabel!
    @IBOutlet weak var endTimeNum: UILabel!
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let setting = SettingDAO(settingForm!)
        //TODO: update setting changes to database
        if (!setting.saveSettingIntoLocalDB()){
            setting.updateSettingInLocalDB(settingId: TaskManager.sharedTaskManager.getSetting().getSettingID(), notification: settingForm?.isNotificationOn(), defaultView: settingForm?.getDefaultView(), defaultSort: settingForm?.getDefaultSort(),
                theme: settingForm?.getTheme(), availableDays: settingForm?.getAvailableDays(), startTime: settingForm?.getStartTime(), endTime: settingForm?.getEndTime())
        }
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
        } else if (sender.selectedSegmentIndex == 1) {
            //Switch to Prority based sorting
            settingForm?.setDefaultSort(SortingType(rawValue: 1)!)
        }
    }
    
    @IBAction func themeSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Light Theme
            settingForm?.setTheme(Theme(rawValue: 0)!)
        } else if (sender.selectedSegmentIndex == 1){
            //Switch to Dark Theme
            settingForm?.setTheme(Theme(rawValue: 1)!)
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
    }
    
    //PickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if (pickerView == startTimePicker){
            return String(startHoursArray[row])
        } else {
            return String(endHoursArray[row])
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == startTimePicker){
            return startHoursArray.count
        } else {
            return endHoursArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var temp: Int32
        
        if (pickerView == startTimePicker){
            temp = (settingForm?.getStartTime())!
            
            settingForm?.setStartTime(startHoursArray[row])
            
            if (!(settingForm?.verificateTime())!){
                createTimeWarning(title: "Invalid Start Time", message: "Start Time has to be eariler than End Time")
                settingForm?.setStartTime(temp)
            }
            
        } else if (pickerView == endTimePicker){
            temp = (settingForm?.getEndTime())!
            
            settingForm?.setEndTime(endHoursArray[row])
            
            if (!(settingForm?.verificateTime())!){
                createTimeWarning(title: "Invalid End Time", message: "End Time has to be later than Start Time")
                settingForm?.setEndTime(temp)
            }
            
        }
        
        startTimeNum.text = String(settingForm!.getStartTime())
        endTimeNum.text = String(settingForm!.getEndTime())
    }
    
    func createTimeWarning (title:String, message:String){
        let timeWarning = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        timeWarning.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:{ (action) in
            timeWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(timeWarning, animated: true, completion: nil)
    }
}

