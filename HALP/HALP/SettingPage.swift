//
//  SettingPage.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit
import CFNetwork



class SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var viewName = "Setting Page"
    var settingForm: SettingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
    
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
    
    //Could have: Loop the data
    @IBOutlet weak var startTimePicker: UIPickerView!
    @IBOutlet weak var endTimePicker: UIPickerView!
    let startHoursArray: Array<Int32> = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    let endHoursArray: Array<Int32> = [24,23,22,21,20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0]
    
    @IBOutlet weak var startTimeNum: UILabel!
    @IBOutlet weak var endTimeNum: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.barTintColor = TaskManager.sharedTaskManager.getTheme().background
        
        notificationSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        notificationSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        sortingMethodSeg.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        themeSeg.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        sunSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        sunSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        monSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        monSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        tueSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        tueSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        wedSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        wedSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        thuSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        thuSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        friSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        friSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        satSwitch.tintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        satSwitch.onTintColor = TaskManager.sharedTaskManager.getTheme().imgTint
        Discard.backgroundColor = TaskManager.sharedTaskManager.getTheme().imgTint
        Reset.backgroundColor = TaskManager.sharedTaskManager.getTheme().imgTint
        
        Reset.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
        Discard.backgroundColor = TaskManager.sharedTaskManager.getTheme().background
        
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
        sunSwitch.anchor(top: themeSeg.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 40, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        monSwitch.anchor(top: sunSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 13, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        tueSwitch.anchor(top: monSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 13, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        wedSwitch.anchor(top: tueSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 13, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        thuSwitch.anchor(top: wedSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 13, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        friSwitch.anchor(top: thuSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 13, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)
        satSwitch.anchor(top: friSwitch.bottomAnchor, left: nil, right: self.view.rightAnchor, bottom: nil, topConstant: 13, leftConstant: 0, rightConstant: 15, bottomConstant: 0, width: 0, height: 0, centerX: nil, centerY: nil)

        
        
        /*let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        logoutButton.addTarget(self, action: #selector(Logout), for: .touchUpInside)
        let logoutBarButton = UIBarButtonItem(customView: logoutButton)*/
        //let logoutButton = UIBarButtonItem(image: #imageLiteral(resourceName: "logout"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(Logout))
        //let negativeSpacer:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        //negativeSpacer.width = 2000
        /*
        logoutButton.width = 10
        self.navigationItem.rightBarButtonItem = logoutButton
        
        let syncButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sync"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.plain, target: self, action: #selector(sync))
        self.navigationItem.leftBarButtonItem = syncButton
 */
        let logoutButton = UIButton(type: .custom)
        logoutButton.setImage(#imageLiteral(resourceName: "logout"), for: .normal)
        logoutButton.imageView?.tintColor = .white
        //logoutButton.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        logoutButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        //        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
        logoutButton.imageView?.contentMode = .scaleAspectFit
        logoutButton.addTarget(self, action: #selector(Logout), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: logoutButton)
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        let syncButton = UIButton(type: .custom)
        syncButton.setImage(#imageLiteral(resourceName: "sync"), for: .normal)
        syncButton.imageView?.tintColor = .white
        //syncButton.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        syncButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        //        button.frame = CGRect(x: 0.0, y: 0.0, width: 35.0, height: 35.0)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Discard.titleLabel!.textAlignment = .center
        Reset.titleLabel!.textAlignment = .center

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let newSetting = Setting(setting: settingForm.getSettingID(), notification: settingForm.isNotificationOn(),
                                 theme: settingForm.getTheme(), summary: settingForm.getSummary(),
                                 defaultSort: settingForm.getDefaultSort(), availableDays: settingForm.getAvailableDays(),
                                 startTime: settingForm.getStartTime(), endTime: settingForm.getEndTime(),
                                 user: settingForm.getUserID())
        
        TaskManager.sharedTaskManager.updateSetting(setting: newSetting)
        print(settingForm.getAvailableDays())
        
    }
    
	@IBAction func Discard(_ sender: Any) {
		createDiscardWarning(title: "Are you sure?", message: "Do you want to discard all changes?")
	}
	
	@objc func Logout() {
        createLogoutWarning(title: "Do you want to logout?", message: "You will lose all changes." )
    }
    
    @IBAction func notificationSwitch(_ sender: UISwitch) {
        settingForm.toggleNotification()
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
        createResetWarning(title: "Are you sure?", message: "Do you want to reset to default?")
    }
	
	func createDiscardWarning (title: String, message: String) {
		let discardWarning = UIAlertController(title:title, message:message, preferredStyle:UIAlertControllerStyle.alert)
		
		discardWarning.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
			discardWarning.dismiss(animated: true, completion: nil)
			
			//change the states of toggles displayed
			//Create a settingForm object
			self.settingForm = SettingForm(TaskManager.sharedTaskManager.getSetting())
			//initialize databse settings
			
			/*
			print(self.settingForm.getSettingID())
			print(self.settingForm.getDefaultView())
			print(self.settingForm.getDefaultSort())
			print(self.settingForm.getAvailableDays())
			print(self.settingForm.isNotificationOn())
			print(self.settingForm.getTheme())
			print(self.settingForm.getStartTime())
			print(self.settingForm.getEndTime())
			*/
			self.notificationSwitch.setOn((!(self.settingForm.isNotificationOn())), animated: true)
			
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
            
            //reset settings in database
			/*
            if (!(self.settingForm.isNotificationOn())){
                self.settingForm.toggleNotification()
            }
			*/
			
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
    
    @objc func sync() {
        if TaskManager.sharedTaskManager.getUser().getUserID() == 0 {
            print("cannot sync guest user")
        } else {
            syncDatabase(userId: TaskManager.sharedTaskManager.getUser().getUserID(), completion: { (flag) in
                if flag {
                    TaskManager.sharedTaskManager.clear()
                    do {
                        try TaskManager.sharedTaskManager.loadTasks()
                    } catch {
                        print("Error")
                    }
                }
                else {
                   
                }
            })
        }
    }
    
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
					print( "Request: ", error == nil )
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

