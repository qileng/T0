//
//  SettingPage.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit
import CFNetwork


// The setting page, which utilizes UIPickerView
class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var viewName = "Setting Page"
    
    // Access setting data from task manager
    var settingForm: SettingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
    
    // Connect storyboard compnents to the code
    @IBOutlet weak var Discard: UIButton!
    @IBOutlet weak var Reset: UIButton!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var sortingMethodSeg: UISegmentedControl!
    @IBOutlet weak var themeSeg: UISegmentedControl!
    @IBOutlet weak var sunSwitch: UISwitch!
    @IBOutlet weak var monSwitch: UISwitch!
    @IBOutlet weak var tueSwitch: UISwitch!
    @IBOutlet weak var wedSwitch: UISwitch!
    @IBOutlet weak var thuSwitch: UISwitch!
    @IBOutlet weak var friSwitch: UISwitch!
    @IBOutlet weak var satSwitch: UISwitch!
    
    @IBOutlet weak var notification: UILabel!
    @IBOutlet weak var defaultSortingMethod: UILabel!
    @IBOutlet weak var defaultTheme: UILabel!
    @IBOutlet weak var selectDaysAvailable: UILabel!
    @IBOutlet weak var sunday: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var startNum: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var endNum: UILabel!
    
    // Could have: Loop the data
    @IBOutlet weak var startTimePicker: UIPickerView!
    @IBOutlet weak var endTimePicker: UIPickerView!
    
    // Data source for UIPickerView
    let startHoursArray: Array<Int32> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    let endHoursArray: Array<Int32> = [24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
    
    @IBOutlet weak var startTimeNum: UILabel!
    @IBOutlet weak var endTimeNum: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Anchor all the buttons to desired position
        notification.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 10, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        notificationSwitch.anchor(top: self.view.topAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10
            , leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        defaultSortingMethod.anchor(top: notification.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        sortingMethodSeg.anchor(top: notificationSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        defaultTheme.anchor(top: defaultSortingMethod.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        themeSeg.anchor(top: sortingMethodSeg.bottomAnchor, left: sortingMethodSeg.leftAnchor, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        selectDaysAvailable.anchor(top: defaultTheme.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        sunday.anchor(top: selectDaysAvailable.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        monday.anchor(top: sunday.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        tuesday.anchor(top: monday.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        wednesday.anchor(top: tuesday.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        thursday.anchor(top: wednesday.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        friday.anchor(top: thursday.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        saturday.anchor(top: friday.bottomAnchor, left: self.view.leftAnchor, right: nil, bottom: nil, topConstant: 20, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: 0, height: 0,centerX: nil, centerY: nil)
        sunSwitch.anchor(top: themeSeg.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 50, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        monSwitch.anchor(top: sunSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        tueSwitch.anchor(top: monSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        wedSwitch.anchor(top: tueSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        thuSwitch.anchor(top: wedSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        friSwitch.anchor(top: thuSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        satSwitch.anchor(top: friSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 10, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)

        // Log out button
        // The user taps on this button to log out their account
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        logoutButton.imageView?.tintColor = .white
        logoutButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        logoutButton.imageView?.contentMode = .scaleAspectFit
        logoutButton.addTarget(self, action: #selector(Logout), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: logoutButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        // Sync button
        // The user taps on this button to sync local and online database
        let syncButton = UIButton(type: .custom)
        syncButton.setImage(#imageLiteral(resourceName: "sync"), for: .normal)
        syncButton.imageView?.tintColor = .white
        syncButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        syncButton.imageView?.contentMode = .scaleAspectFit
        syncButton.addTarget(self, action: #selector(sync), for: .touchUpInside)
        let barButtonItem1 = UIBarButtonItem(customView: syncButton)
        self.navigationItem.leftBarButtonItem = barButtonItem1
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Prompt past task alerts
        TaskManager.sharedTaskManager.promptNextAlert(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Method to switch the theme between dark and light
	fileprivate func changeTheme(_ with: ColorTheme) {
		notificationSwitch.tintColor = with.imgTint
		notificationSwitch.onTintColor = with.imgTint
		sortingMethodSeg.tintColor = with.imgTint
		themeSeg.tintColor = with.imgTint
		sunSwitch.tintColor = with.imgTint
		sunSwitch.onTintColor = with.imgTint
		monSwitch.tintColor = with.imgTint
		monSwitch.onTintColor = with.imgTint
		tueSwitch.tintColor = with.imgTint
		tueSwitch.onTintColor = with.imgTint
		wedSwitch.tintColor = with.imgTint
		wedSwitch.onTintColor = with.imgTint
		thuSwitch.tintColor = with.imgTint
		thuSwitch.onTintColor = with.imgTint
		friSwitch.tintColor = with.imgTint
		friSwitch.onTintColor = with.imgTint
		satSwitch.tintColor = with.imgTint
		satSwitch.onTintColor = with.imgTint
		Discard.backgroundColor = with.imgTint
		Reset.backgroundColor = with.imgTint
		
		Reset.backgroundColor = with.background
		Discard.backgroundColor = with.background
		
		self.navigationController!.navigationBar.barTintColor = with.background
		self.navigationController!.navigationBar.setNeedsLayout()
		self.navigationController!.navigationBar.layoutIfNeeded()
		self.navigationController!.navigationBar.setNeedsDisplay()
	}
	
	override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Discard.titleLabel!.textAlignment = .center
        Reset.titleLabel!.textAlignment = .center
        
		changeTheme(TaskManager.sharedTaskManager.getTheme())
		
        TaskManager.sharedTaskManager.refreshTaskManager()
        
        //Create a settingForm object
        settingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
        //initialize databse settings
        if (!(settingForm.isNotificationOn())){
            notificationSwitch.setOn(false, animated: false)
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
            sunSwitch.setOn(false, animated: false)
        }
        if (((settingForm.getAvailableDays()) >> 1) & 0b1 == 0){
            monSwitch.setOn(false, animated: false)
        }
        if (((settingForm.getAvailableDays()) >> 2) & 0b1 == 0){
            tueSwitch.setOn(false, animated: false)
        }
        if (((settingForm.getAvailableDays()) >> 3) & 0b1 == 0){
            wedSwitch.setOn(false, animated: false)
        }
        if (((settingForm.getAvailableDays()) >> 4) & 0b1 == 0){
            thuSwitch.setOn(false, animated: false)
        }
        if (((settingForm.getAvailableDays()) >> 5) & 0b1 == 0){
            friSwitch.setOn(false, animated: false)
        }
        if (((settingForm.getAvailableDays()) >> 6) & 0b1 == 0){
            satSwitch.setOn(false, animated: false)
        }
        startTimeNum.text = String(settingForm.getStartTime())
        endTimeNum.text = String(settingForm.getEndTime())
        
        startTimePicker.selectRow(Int(settingForm.getStartTime()), inComponent: 0, animated: false)
        endTimePicker.selectRow(Int(24 - settingForm.getEndTime()), inComponent: 0, animated:false)
	}
    
    // Everytime the user swipe out of the setting page, we save current setting into task manager
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
	    if settingForm.getAvailableDays() == 0 {
                sunSwitch.setOn(true, animated: false)
                monSwitch.setOn(true, animated: false)
                tueSwitch.setOn(true, animated: false)
                wedSwitch.setOn(true, animated: false)
                thuSwitch.setOn(true, animated: false)
                friSwitch.setOn(true, animated: false)
                satSwitch.setOn(true, animated: false)
                settingForm.setAvailableDays(127)
        }
        
        let newSetting = Setting(setting: settingForm.getSettingID(), notification: settingForm.isNotificationOn(),
                                 theme: settingForm.getTheme(), summary: settingForm.getSummary(),
                                 defaultSort: settingForm.getDefaultSort(), availableDays: settingForm.getAvailableDays(),
                                 startTime: settingForm.getStartTime(), endTime: settingForm.getEndTime(),
                                 user: settingForm.getUserID())
        
        TaskManager.sharedTaskManager.updateSetting(setting: newSetting)
        
    }
    
    // Discard current changes
	@IBAction func Discard(_ sender: Any) {
		createDiscardWarning(title: "Are you sure?", message: "Do you want to discard all changes?")
	}
	
    // Logout account
	@objc func Logout() {
        createLogoutWarning(title: "Do you want to logout?", message: "You will lose all changes." )
    }
    
    // Turn on/off system notification
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        settingForm.toggleNotification()
    }
    
    // Default sorting method for list view
    @IBAction func defaultSortingMethodSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Time based sorting
            settingForm.setDefaultSort(SortingType(rawValue: 0)!)
        } else if (sender.selectedSegmentIndex == 1) {
            //Switch to Prority based sorting
            settingForm.setDefaultSort(SortingType(rawValue: 1)!)
        }
    }
    
    // Switch between light and dark theme
    @IBAction func themeSegControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            //Switch to Light Theme
            settingForm.setTheme(Theme(rawValue: 0)!)
			changeTheme(ColorTheme.regular)
        } else if (sender.selectedSegmentIndex == 1){
            //Switch to Dark Theme
            settingForm.setTheme(Theme(rawValue: 1)!)
			changeTheme(ColorTheme.dark)
        }
    }
    
    // Seven toggles
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
    
    // Pops up if the user enters invalid start time and end time
    func createTimeWarning (title:String, message:String){
        let timeWarning = UIAlertController(title:title, message:message, preferredStyle: UIAlertControllerStyle.alert)
        timeWarning.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.default, handler:{ (action) in
            timeWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(timeWarning, animated: true, completion: nil)

    }
    
    // Ask the user if they really want to reset all setting to default
    @IBAction func reset(_ sender: UIButton) {
        createResetWarning(title: "Are you sure?", message: "Do you want to reset to default?")
    }
	
    // Ask the user if they really want to discard all changes to setting
	func createDiscardWarning (title: String, message: String) {
		let discardWarning = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
		
		discardWarning.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
			discardWarning.dismiss(animated: true, completion: nil)
			
			//change the states of toggles displayed
			//Create a settingForm object
			self.settingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
			//initialize databse settings

			self.notificationSwitch.setOn(((self.settingForm.isNotificationOn())), animated: true)
			
			if (self.settingForm.getDefaultSort().rawValue == 1){
				self.sortingMethodSeg.selectedSegmentIndex = 1
			}
			else {
				self.sortingMethodSeg.selectedSegmentIndex = 0
			}
			
			if (self.settingForm.getTheme().rawValue == 1){
				self.themeSeg.selectedSegmentIndex = 1
			}
			else {
				self.themeSeg.selectedSegmentIndex = 0
			}
			
			self.sunSwitch.setOn(((self.settingForm.getAvailableDays()) & 0b1 == 1), animated: true)
			self.monSwitch.setOn((((self.settingForm.getAvailableDays()) >> 1) & 0b1 == 1), animated: true)
			self.tueSwitch.setOn((((self.settingForm.getAvailableDays()) >> 2) & 0b1 == 1), animated: true)
			self.wedSwitch.setOn((((self.settingForm.getAvailableDays()) >> 3) & 0b1 == 1), animated: true)
			self.thuSwitch.setOn((((self.settingForm.getAvailableDays()) >> 4) & 0b1 == 1), animated: true)
			self.friSwitch.setOn((((self.settingForm.getAvailableDays()) >> 5) & 0b1 == 1), animated: true)
			self.satSwitch.setOn((((self.settingForm.getAvailableDays()) >> 6) & 0b1 == 1), animated: true)
			self.startTimeNum.text = String(self.settingForm.getStartTime())
			self.endTimeNum.text = String(self.settingForm.getEndTime())
			self.startTimePicker.selectRow(Int(self.settingForm.getStartTime()), inComponent: 0, animated: true)
			self.endTimePicker.selectRow(24 - Int(self.settingForm.getEndTime()), inComponent: 0, animated: true)
			
			self.changeTheme(TaskManager.sharedTaskManager.getTheme())
		}))
		discardWarning.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
			discardWarning.dismiss(animated: true, completion: nil)
		}))
		self.present(discardWarning, animated:true, completion: nil)
	}

	func createResetWarning (title:String, message: String) {
        let resetWarning = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
        
        resetWarning.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            resetWarning.dismiss(animated: true, completion: nil)
			
			self.changeTheme(.regular)
            
            //change the states of toggles displayed
            self.notificationSwitch.setOn(true, animated: true)
            self.sortingMethodSeg.selectedSegmentIndex = 0
            self.themeSeg.selectedSegmentIndex = 0
            self.sunSwitch.setOn(true, animated: true)
            self.monSwitch.setOn(true, animated: true)
            self.tueSwitch.setOn(true, animated: true)
            self.wedSwitch.setOn(true, animated: true)
            self.thuSwitch.setOn(true, animated: true)
            self.friSwitch.setOn(true, animated: true)
            self.satSwitch.setOn(true, animated:true)
            self.startTimePicker.selectRow(8, inComponent: 0, animated: true)
            self.endTimePicker.selectRow(0, inComponent: 0, animated: true)
			
            self.settingForm.setDefaultSort(SortingType(rawValue: 0)!)
            self.settingForm.setTheme(Theme(rawValue: 0)!)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<0)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<1)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<2)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<3)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<4)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<5)
            self.settingForm.setAvailableDays((self.settingForm.getAvailableDays()) | 1<<6)
            self.settingForm.setStartTime(24)
            self.settingForm.setEndTime(0)
        }))
        
        resetWarning.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            resetWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(resetWarning, animated:true, completion: nil)
    }
    
    // Sync online and local database
    @objc func sync() {
        if TaskManager.sharedTaskManager.getUser().getUserID() == 0 {
            createTimeWarning(title: "Warning", message: "Cannot sync guest user")
        } else {
            syncDatabase(userId: TaskManager.sharedTaskManager.getUser().getUserID(), completion: { (flag) in
                if flag {
                    TaskManager.sharedTaskManager.clear()
                    do {
                        try TaskManager.sharedTaskManager.loadTasks()
                        self.createTimeWarning(title: "Done", message: "Sync successfully")
                    } catch {
                        print("Error")
                    }
                }
                else {
                }
            })
        }
    }
    
    // Ask user if they want to logout
    func createLogoutWarning (title:String, message:String){
        
        _ = clearSavedUser()
        let logoutWarning = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
        
        logoutWarning.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
            logoutWarning.dismiss(animated: true, completion: nil)
            if TaskManager.sharedTaskManager.getUser().getUserID() == 0 {
                let loginVC:StartupViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
                let loginSignUpNC: UINavigationController = UINavigationController(rootViewController: loginVC)
                self.present(loginSignUpNC, animated: true, completion: nil)
                
            } else {
				let loginVC:StartupViewController = self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
				let loginSignUpNC: UINavigationController = UINavigationController(rootViewController: loginVC)
				self.present(loginSignUpNC, animated: true, completion: nil)
				
				let url = URL(string: Database.database().reference().description())
				
				let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in
					if error != nil {
					} else {
						syncDatabase(userId: TaskManager.sharedTaskManager.getUser().getUserID(), completion: { (flag) in
						})
					}
				}
				
				task.resume()
            }
        }))
        logoutWarning.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            logoutWarning.dismiss(animated: true, completion: nil)
        }))
        self.present(logoutWarning, animated:true, completion: nil)
       
    }
}
