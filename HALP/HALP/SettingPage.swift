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
    var settingForm: SettingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var viewSeg: UISegmentedControl!
    @IBOutlet weak var sortingMethodSeg: UISegmentedControl!
    @IBOutlet weak var themeSeg: UISegmentedControl!
    @IBOutlet weak var sunSwitch: UISwitch!
    @IBOutlet weak var monSwitch: UISwitch!
    @IBOutlet weak var tueSwitch: UISwitch!
    @IBOutlet weak var wedSwitch: UISwitch!
    @IBOutlet weak var thuSwitch: UISwitch!
    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satSwitch: UISwitch!
    
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
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		// Prompt past task alerts
		TaskManager.sharedTaskManager.promptNextAlert(self)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		TaskManager.sharedTaskManager.refreshTaskManager()
		
        //Create a settingForm object
        settingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
        //initialize databse settings
        
        /* testing purpose
        print(settingForm.getSettingID())
        print(settingForm.getDefaultView())
        print(settingForm.getDefaultSort())
        print(settingForm.getAvailableDays())
        print(settingForm.isNotificationOn())
        print(settingForm.getTheme())
        print(settingForm.getStartTime())
        print(settingForm.getEndTime())*/
        
        if (!(settingForm.isNotificationOn())){
            notificationSwitch.setOn(false, animated: true)
        }
        
        if (settingForm.getDefaultView().rawValue == 1){
            viewSeg.selectedSegmentIndex = 1
        } else {
            viewSeg.selectedSegmentIndex = 0
        }
        
        if (settingForm.getDefaultSort().rawValue == 1){
            sortingMethodSeg.selectedSegmentIndex = 1
        }
        else {
            sortingMethodSeg.selectedSegmentIndex = 0
        }
        
        if (settingForm.getTheme().rawValue == 1){
            themeSeg.selectedSegmentIndex = 1
        }
        else {
            themeSeg.selectedSegmentIndex = 0
        }

        if ((settingForm.getAvailableDays()) & 0b1 == 0){
            sunSwitch.setOn(false, animated: true)
        }
        if (((settingForm.getAvailableDays()) >> 1) & 0b1 == 0){
            monSwitch.setOn(false, animated: true)
        }
        if (((settingForm.getAvailableDays()) >> 2) & 0b1 == 0){
            tueSwitch.setOn(false, animated: true)
        }
        if (((settingForm.getAvailableDays()) >> 3) & 0b1 == 0){
            wedSwitch.setOn(false, animated: true)
        }
        if (((settingForm.getAvailableDays()) >> 4) & 0b1 == 0){
            thuSwitch.setOn(false, animated: true)
        }
        if (((settingForm.getAvailableDays()) >> 5) & 0b1 == 0){
            friSwitch.setOn(false, animated: true)
        }
        if (((settingForm.getAvailableDays()) >> 6) & 0b1 == 0){
            satSwitch.setOn(false, animated: true)
        }
        startTimeNum.text = String(settingForm.getStartTime())
        endTimeNum.text = String(settingForm.getEndTime())
	}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newSetting = Setting(setting: settingForm.getSettingID(), notification: settingForm.isNotificationOn(),
                                 theme: settingForm.getTheme(), defaultView: settingForm.getDefaultView(),
                                 defaultSort: settingForm.getDefaultSort(), availableDays: settingForm.getAvailableDays(),
                                 startTime: settingForm.getStartTime(), endTime: settingForm.getEndTime(),
                                 user: settingForm.getUserID())
        
        TaskManager.sharedTaskManager.updateSetting(setting: newSetting)
        
    }
    
    @IBAction func Logout(_ sender: Any) {
        createLogoutWarning(title: "Are you sure?", message: "Do you want to logout?")
    }
    
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        settingForm.toggleNotification()
    }
    
    @IBAction func defaultViewSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Clock View
            settingForm.setDefaultView(View(rawValue: 0)!)
        } else if (sender.selectedSegmentIndex == 1) {
            //Switch to List View
            settingForm.setDefaultView(View(rawValue: 1)!)
        }
    }
    
    @IBAction func defaultSortingMethodSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Time based sorting
            settingForm.setDefaultSort(SortingType(rawValue: 0)!)
        } else if (sender.selectedSegmentIndex == 1) {
            //Switch to Prority based sorting
            settingForm.setDefaultSort(SortingType(rawValue: 1)!)
        }
    }
    
    @IBAction func themeSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Light Theme
            settingForm.setTheme(Theme(rawValue: 0)!)
        } else if (sender.selectedSegmentIndex == 1){
            //Switch to Dark Theme
            settingForm.setTheme(Theme(rawValue: 1)!)
        }
    }
    
    //Seven toggles
    @IBAction func sunSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<0)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b1111110)
        }
    }
    
    @IBAction func monSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<1)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b1111101)
        }
    }
    
    @IBAction func tueSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<2)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b1111011)
        }
    }
    
    @IBAction func wedSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<3)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b1110111)
        }
    }
    
    @IBAction func thuSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<4)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b1101111)
        }
    }
    
    @IBAction func friSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<5)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b1011111)
        }
    }
    
    @IBAction func satSwitch(_ sender: UISwitch) {
        if (sender.isOn == true){
            settingForm.setAvailableDays((settingForm.getAvailableDays()) | 1<<6)
        } else {
            settingForm.setAvailableDays((settingForm.getAvailableDays()) & 0b0111111)
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
            temp = (settingForm.getStartTime())
            
            settingForm.setStartTime(startHoursArray[row])
            
            if (!(settingForm.verificateTime())){
                createTimeWarning(title: "Invalid Start Time", message: "Start Time has to be eariler than End Time")
                settingForm.setStartTime(temp)
            }
            
        } else if (pickerView == endTimePicker){
            temp = (settingForm.getEndTime())
            
            settingForm.setEndTime(endHoursArray[row])
            
            if (!(settingForm.verificateTime())){
                createTimeWarning(title: "Invalid End Time", message: "End Time has to be later than Start Time")
                settingForm.setEndTime(temp)
            }
            
        }
        
        startTimeNum.text = String(settingForm.getStartTime())
        endTimeNum.text = String(settingForm.getEndTime())
    }
    
    func createTimeWarning (title:String, message:String){
        let timeWarning = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        timeWarning.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:{ (action) in
            timeWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(timeWarning, animated: true, completion: nil)

    }
    
    @IBAction func reset(_ sender: UIButton) {
        createResetWarning(title: "Are you sure?", message: "Do you want to reset?")
    }

    func createResetWarning (title:String, message: String){
        let resetWarning = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
        
        resetWarning.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            resetWarning.dismiss(animated: true, completion: nil)
            
            //change the states of toggles displayed
            self.notificationSwitch.setOn(true, animated: true)
            self.viewSeg.selectedSegmentIndex = 0
            self.sortingMethodSeg.selectedSegmentIndex = 0
            self.themeSeg.selectedSegmentIndex = 0
            self.sunSwitch.setOn(true, animated: true)
            self.monSwitch.setOn(true, animated: true)
            self.tueSwitch.setOn(true, animated: true)
            self.wedSwitch.setOn(true, animated: true)
            self.thuSwitch.setOn(true, animated: true)
            self.friSwitch.setOn(true, animated: true)
            self.satSwitch.setOn(true, animated:true)
            self.startTimePicker.selectRow(0, inComponent: 0, animated: true)
            self.endTimePicker.selectRow(0, inComponent: 0, animated: true)
            
            //reset settings in database
            if (!(self.settingForm.isNotificationOn())){
                self.settingForm.toggleNotification()
            }
            self.settingForm.setDefaultView(View(rawValue: 0)!)
            self.settingForm.setDefaultSort(SortingType(rawValue: 0)!)
            self.settingForm.setTheme(Theme(rawValue: 0)!)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<0)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<1)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<2)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<3)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<4)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<5)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<6)
            self.settingForm.setStartTime(0)
            self.settingForm.setEndTime(0)
        }))
        
        resetWarning.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            resetWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(resetWarning, animated:true, completion: nil)
    }
    
    @IBAction func sync(_ sender: UIButton) {
        syncDatabase(userId: TaskManager.sharedTaskManager.getUser().getUserID(), completion: { (flag) in
            if flag {
                TaskManager.sharedTaskManager.clear()
                do {
                     try TaskManager.sharedTaskManager.loadTasks()
                } catch {
                    print("Error")
                }
                print("Done")
            }
            else {
                print("Success")
            }
        })
    }
    
    func createLogoutWarning (title:String, message:String){
        let logoutWarning = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
        
        logoutWarning.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            logoutWarning.dismiss(animated: true, completion: nil)
            let loginVC:StartupViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
            let loginSignUpNC: UINavigationController = UINavigationController(rootViewController: loginVC)
            self.present(loginSignUpNC, animated: true, completion: nil)
        }))
        
        logoutWarning.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            logoutWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(logoutWarning, animated:true, completion: nil)
    }
}

