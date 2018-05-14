//
//  Startup.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import SQLite3
import UIKit


class StartupViewController: UIViewController {
	
	@IBOutlet weak var Email: UITextField!
	@IBOutlet weak var Password: UITextField!
	
	@IBAction func SignUp(_ sender: UIButton) {
		let storyBoard = self.storyboard
		let nextViewController = storyBoard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
		self.present(nextViewController, animated: true, completion: nil)
    
	}
	
    @IBAction func GuestLogin(_ sender: Any) {
        //Dummy password and email for guest account
        let guestForm = UserForm(password: "GUEST", email: "GUEST@GUEST.com")
        
        let guest: UserData
        do {
            guest = try guestForm.onlineValidateExistingUser()
            // TODO: retrieve guest setting
            // Set up task manager
			TaskManager.sharedTaskManager.setUp(new: guest, setting: Setting(), caller: self as UIViewController)
			
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
        } catch {
            //There should not be any authentication error with guest login
            //All error should be directed here
            let alert = UIAlertController(title: "Oops!", message: "Unexpected Error!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func Login(_ sender: UIButton) {
		
		// UserForm collects input.
		let form = UserForm(password: self.Password!.text!, email: self.Email!.text!)
		// Validate with DB using via UserData.
		// TODO: Currently, actual online authentication is not implemented. So authentication is in
		// SQLite as a template. To enable authentication from Azure, implement
		// UserData.init(Bool:email:password).
		let user: UserData
		do {
			user = try form.onlineValidateExistingUser()
			// TODO: retrieve settting using userID
			// Set up task manager
			// TaskManager.sharedTaskManager.setUp(new: user, setting: )
            
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
	
	// This function handles everything that needs to be set up once for this UI.
	// This function is called only after the UIViewController is loaded and never again.
	override func viewDidLoad() {
		super.viewDidLoad()
        
        // Initialize local database
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = documentsPath + "/appData.sqlite"
        var dbpointer: OpaquePointer? = nil
        
        if sqlite3_open(dbPath, &dbpointer) == SQLITE_OK {
            // UserData table
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS UserData" +
                "(user_id INTEGER PRIMARY KEY, user_name TEXT, password TEXT, email TEXT, last_update INTEGER)", nil, nil, nil)
            // Initialize guest account
            sqlite3_exec(dbpointer, "INSERT INTO UserData (user_id, user_name, password, email, last_update) " +
                "VALUES (0, 'GUEST', 'GUEST', 'GUEST@GUEST.com', 0)", nil , nil, nil)
            
            // TaskData table
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS TaskData" +
                "(task_id INTEGER PRIMARY KEY, task_title TEXT, task_desc TEXT, " +
                "category REAL, alarm INTEGER, deadline INTEGER, soft_deadline INTEGER, schedule INTEGER, duration INTEGER, " +
                "task_priority REAL, schedule_start INTEGER, notification INTEGER, user_id INTEGER, last_update INTEGER)", nil, nil, nil)
            
            // SettingData table not yet implemented
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS SettingData" +
                "(setting_id INTEGER PRIMARY KEY, placeholder TEXT)", nil, nil, nil)
			sqlite3_close(dbpointer)
        }
        else {
            print("fail to open database")
        }
	}
	
	// This function I haven't figure out any significant usage yet. 		--Qihao
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	
	// This function handles everything that needs to be set up everytime for this UI.
	// This function is called after each time the UIViewController is brought to front.
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
}

