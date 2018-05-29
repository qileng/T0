//
//  Startup.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import SQLite3
import UIKit


let colorTheme = UIColor.HalpColors.paleCopper
class StartupViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    // UI components
    let logoImageView: UIImageView = {
        let image = UIImage(named: "logo")//?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
//        imageView.tintColor = colorTheme
        return imageView
    }()
    
    let emailTextField:LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.tag = 1
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField:LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.isSecureTextEntry = true
        textField.tag = 2
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let loginButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = colorTheme
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.alpha = 0.4
        button.addTarget(self, action: #selector(loginActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let guestLoginButton:UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Guest Login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = colorTheme
        button.layer.cornerRadius = 5
        button.isEnabled = true
        button.alpha = 1
        button.addTarget(self, action: #selector(guestLoginActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let hidePasswordButton:UIButton = {
        
        let button = UIButton(type: .custom)
        let checkedBoxImg = UIImage(named: "checkedBox")?.withRenderingMode(.alwaysTemplate)
        let uncheckedBoxImg = UIImage(named: "uncheckedBox")?.withRenderingMode(.alwaysTemplate)
        button.setImage(checkedBoxImg, for: .normal)
        button.setImage(uncheckedBoxImg, for: .selected)

        let attributedTitle = NSMutableAttributedString(string: "Hide Password", attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.tintColor = colorTheme
        button.imageView?.contentMode = .scaleAspectFit
        
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, button.frame.width - button.frame.height ,0)
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, -23, 0, 0)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(hidePasswordButtonHandler), for: .touchUpInside)
        
        return button
    }()

    let forgotPasswordButton:UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Forgot password?", attributes: [ NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : colorTheme ])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(forgotPasswordButtonHandler), for: .touchUpInside)
        return button
    }()
    
    let horizontalStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        stackView.backgroundColor = .red
        stackView.spacing = 10
        return stackView
    }()
    
    let verticalStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
//        stackView.backgroundColor = .red
        stackView.spacing = 10
        return stackView
    }()
    
    let signUpButton:UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [ NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.lightGray ])
        attributedTitle.append(NSAttributedString(string: "Sign up.", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : colorTheme]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(signUpActionHandler), for: .touchUpInside)
        
        return button
    }()
    
    let lineView:UIView = {
        let lineView = UIView()
        lineView.layer.borderWidth = 1
        lineView.layer.borderColor = UIColor.rgbColor(220, 220, 220).cgColor
        return lineView
    }()
    
    // End of UI components
    
    // Setup UI components
    fileprivate func setUpSubViewsLayout()
    {
        horizontalStackView.addArrangedSubViews([hidePasswordButton, forgotPasswordButton])
        verticalStackView.addArrangedSubViews([emailTextField, passwordTextField, horizontalStackView, loginButton, guestLoginButton ])
        view.addSubviews([logoImageView, verticalStackView, lineView, signUpButton])
        
        signUpButton.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: view.frame.width, height: 45, centerX: nil, centerY: nil)
        
        lineView.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: self.signUpButton.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: view.frame.width, height: 1, centerX: nil, centerY: nil)
        
        verticalStackView.anchor(top: nil, left: view.leftAnchor, right: view.rightAnchor, bottom: self.lineView.topAnchor, topConstant: 0, leftConstant: 10, rightConstant: 10, bottomConstant: view.frame.height/5, width: view.frame.width-20, height: view.frame.height/3, centerX: view.centerXAnchor, centerY: nil)
        
        logoImageView.anchor(top: nil, left: nil, right: nil, bottom: self.verticalStackView.topAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 50, width: view.frame.width/3, height: view.frame.width/3, centerX: view.centerXAnchor, centerY: nil)
        
//        hidePasswordButton.semanticContentAttribute = .forceRightToLeft
        
//        hidePasswordButton.imageView?.anchor(top: hidePasswordButton.topAnchor, left: hidePasswordButton.leftAnchor, right: nil, bottom: hidePasswordButton.bottomAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, bottomConstant: 0, width: hidePasswordButton.frame.width/5, height: hidePasswordButton.frame.width/5, centerX: nil, centerY: nil)
//        hidePasswordButton.titleLabel?.anchor(top: hidePasswordButton.topAnchor, left: hidePasswordButton.imageView?.rightAnchor, right: nil, bottom: hidePasswordButton.bottomAnchor, topConstant: 0, leftConstant: 15, rightConstant: 0, bottomConstant: 0, width: (hidePasswordButton.titleLabel?.frame.width)!, height: hidePasswordButton.frame.height, centerX: nil, centerY: nil)
 

    }
    
    
    // Logic
    // Login function
    @objc func loginActionHandler()
    {
                // UserForm collects input.
                let form = UserForm(password: self.passwordTextField.text!, email: self.emailTextField.text!)
                // Validate with DB using via UserData.
                // TODO: Currently, actual online authentication is not implemented. So authentication is in
                // SQLite as a template. To enable authentication from Azure, implement
                // UserData.init(Bool:email:password).
                let user: UserData
                do {
                    user = try form.onlineValidateExistingUser()
                    // TODO: retrieve settting using userID
                    // Set up task manager
                    
                    let settingDAO = SettingDAO()
                    do {
                            
                    let settingArray = try settingDAO.fetchSettingFromLocalDB(settingId: user.getUserID())
                        
                        let settingId = settingArray[0] as! Int64
                        let notification = settingArray[1] as! Int32 == 1 ? true : false
                        let theme = settingArray[2] as! Int32 == 1 ? Theme.dark : Theme.regular
                        let view = settingArray[3] as! Int32 == 1 ? View.clock : View.list
                        let sort = settingArray[4] as! Int32 == 1 ? SortingType.time : SortingType.priority
                        let avaliableDays = settingArray[5] as! Int32
                        let start = settingArray[6] as! Int32
                        let end = settingArray[7] as! Int32
                        
                        let userSetting = Setting(setting: settingId, notification: notification, theme: theme,
                            defaultView: view, defaultSort: sort, availableDays: avaliableDays, startTime: start,
                            endTime: end, user: settingId)
                        
                        TaskManager.sharedTaskManager.setUp(new: user, setting: userSetting)
                        
                    }catch {
                        print("Error")
                    }
                    
        
                    // Bring up rootViewController
                    self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
                } catch RuntimeError.DBError(let errorMessage) {
                    let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
        
                } catch RuntimeError.InternalError(let errorMessage) {
                    let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
        
                } catch {
                    let alert = UIAlertController(title: "Oops!", message: "Unexpected Error!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                }
    }
    
    // Sign up function
    @objc func signUpActionHandler()
    {
        let signupVC:SignupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    // Todo:
    // reset password
    @objc func forgotPasswordButtonHandler()
    {
        print("forgot password button touched")
    }
    
    // Guest login
    @objc func guestLoginActionHandler() {
        //Dummy password and email for guest account
        let guestForm = UserForm(password: "GUEST", email: "GUEST@GUEST.com")
        
        let guest: UserData
        do {
            guest = try guestForm.onlineValidateExistingUser()
            // TODO: retrieve guest setting
            // Set up task manager
			
            let settingDAO = SettingDAO()
            do {
                
                let settingArray = try settingDAO.fetchSettingFromLocalDB(settingId: guest.getUserID())
                
                let settingId = settingArray[0] as! Int64
                let notification = settingArray[1] as! Int32 == 1 ? true : false
                let theme = settingArray[2] as! Int32 == 1 ? Theme.dark : Theme.regular
                let view = settingArray[3] as! Int32 == 1 ? View.list : View.clock
                let sort = settingArray[4] as! Int32 == 1 ? SortingType.priority : SortingType.time
                let avaliableDays = settingArray[5] as! Int32
                let start = settingArray[6] as! Int32
                let end = settingArray[7] as! Int32
                
                
                let userSetting = Setting(setting: settingId, notification: notification, theme: theme,
                                          defaultView: view, defaultSort: sort, availableDays: avaliableDays, startTime: start,
                                          endTime: end, user: settingId)
                
                TaskManager.sharedTaskManager.setUp(new: guest, setting: userSetting, caller: self as UIViewController)
             
                // Example usage
//                dbSync(userId: 878442598476046, completion: {(flag) in
//                    if flag {
//                        print("Done")
//                    }
//                })
                
            }catch {
                print("Error")
            }
			
//            self.dismiss(animated: true, completion: nil)
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
        } catch {
            //There should not be any authentication error with guest login
            //All error should be directed here
            let alert = UIAlertController(title: "Oops!", message: "Unexpected Error!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    
    // UI actions
    // Todo: comment
    
//    func progressAlongAxis(_ pointOnAxis: CGFloat, _ axisLength: CGFloat) -> CGFloat {
//        let movementOnAxis = pointOnAxis / axisLength
//        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
//        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
//        return CGFloat(positiveMovementOnAxisPercent)
//    }
//
//    func ensureRange<T>(value: T, minimum: T, maximum: T) -> T where T : Comparable {
//        return min(max(value, minimum), maximum)
//    }
    
    @objc func handleTextInputChange()
    {
        let isFormValid = (emailTextField.text?.count ?? 0) > 0 && (passwordTextField.text?.count ?? 0) > 0
        
        if isFormValid
        {
            loginButton.isEnabled = true
            loginButton.alpha = 1
        } else
        {
            loginButton.isEnabled = false
            loginButton.alpha = 0.4
        }
    }
    
    @objc func hidePasswordButtonHandler()
    {
        hidePasswordButton.isSelected = !hidePasswordButton.isSelected
        if hidePasswordButton.isSelected
        {
            passwordTextField.isSecureTextEntry = false
        
        }else
        {
            passwordTextField.isSecureTextEntry = true
        }
        
    }
    
   @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            let y: CGFloat = UIDevice.current.orientation.isLandscape ? -150 : -80
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch(textField.tag)
        {
        case 1:
            passwordTextField.becomeFirstResponder()
        case 2:
            passwordTextField.resignFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
    
    // Setup the startup page
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector( ) ))
        
        self.navigationController?.isNavigationBarHidden = true
        setUpSubViewsLayout()
        observeKeyboardNotifications()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        // Initialize local database
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = documentsPath + "/appData.sqlite"
		print(dbPath)
        var dbpointer: OpaquePointer? = nil
		/*
		sqlite3_open(dbPath, &dbpointer)
		sqlite3_exec(dbpointer, "DROP TABLE UserData", nil, nil, nil)
		sqlite3_exec(dbpointer, "DROP TABLE TaskData", nil, nil, nil)
		sqlite3_exec(dbpointer, "DROP TABLE SettingData", nil, nil, nil)
		sqlite3_close(dbpointer)
		*/
        
        if sqlite3_open(dbPath, &dbpointer) == SQLITE_OK {
            // UserData table
            // sqlite3_exec(dbpointer, "DROP TABLE UserData", nil, nil, nil)
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS UserData" +
                "(user_id INTEGER PRIMARY KEY, user_name TEXT, password TEXT, email TEXT, last_update INTEGER)", nil, nil, nil)
            // Initialize guest account
            sqlite3_exec(dbpointer, "INSERT INTO UserData (user_id, user_name, password, email, last_update) " +
                "VALUES (0, 'GUEST', 'GUEST', 'GUEST@GUEST.com', 0)", nil , nil, nil)
            
            // TaskData table
            // sqlite3_exec(dbpointer, "DROP TABLE TaskData", nil, nil, nil)
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS TaskData" +
                "(task_id INTEGER PRIMARY KEY, task_title TEXT, task_desc TEXT, " +
                "category REAL, alarm INTEGER, deadline INTEGER, soft_deadline INTEGER, schedule INTEGER, duration INTEGER, " +
                "task_priority REAL, schedule_start INTEGER, notification INTEGER, user_id INTEGER, last_update INTEGER)", nil, nil, nil)
            
            // SettingData table not yet implemented
            // sqlite3_exec(dbpointer, "DROP TABLE SettingData", nil, nil, nil)
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS SettingData" +
                "(setting_id INTEGER PRIMARY KEY, notification INTEGER, default_view INTEGER, default_sort INTEGER, theme INTEGER, avaliable_days INTEGER, start_time INTEGER, end_time INTEGER, last_update INTEGER)", nil, nil, nil)
            
            //Create a default setting for guest login
            sqlite3_exec(dbpointer, "INSERT INTO SettingData (setting_id, notification, default_view, default_sort, theme, avaliable_days, start_time, end_time , last_update) " + "VALUES(0, 1, 0, 0, 0, 127, 0, 0, 0)", nil, nil, nil)
            
            sqlite3_close(dbpointer)
             print(dbPath)
        }
        else {
            print("fail to open database")
        }


		// Testing data
//        var tasks: [Task] = []
//        let current = Int32(Date().timeIntervalSince1970)
//        tasks.append(Task(Title: "Task6", Description: "Testing Task 6", Category: .Study_Work,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 14400, UserID: 0))
//        tasks.append(Task(Title: "Task2", Description: "Testing Task 2", Category: .Chore,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 7200, UserID: 0))
//        tasks.append(Task(Title: "Task5", Description: "Testing Task 5", Category: .Entertainment,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 10800, UserID: 0))
//        tasks.append(Task(Title: "Task4", Description: "Testing Task 4", Category: .Study_Work,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 3600, UserID: 0))
//        tasks.append(Task(Title: "Task1", Description: "Testing Task 1", Category: .Relationship,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 18000, UserID: 0))
//        tasks.append(Task(Title: "Task8", Description: "Testing Task 8", Category: .Study_Work,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 21600, UserID: 0))
//        tasks.append(Task(Title: "Task7", Description: "Testing Task 7", Category: .Chore,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 25200, UserID: 0))
//        tasks.append(Task(Title: "Task3", Description: "Testing Task 3", Category: .Study_Work,  Deadline: current + 36000, Duration: 1800, Schedule_start: current + 28800, UserID: 0))


//        for task in tasks {
//            let DAO = TaskDAO(task)
//            if !DAO.saveTaskInfoToLocalDB() {
//                print("Saving ", task.getTitle(), " failed!")
//            }
//        }

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

