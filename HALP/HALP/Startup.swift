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
	
	@IBAction func Login(_ sender: UIButton) {
        
        /*
		let form = UserForm(password: self.Password!.text!, email: self.Email!.text!)
		// TODO: perform login validation
		if !form.onlineValidateExistingUser() {
			return
		}
         */
		
		// TODO: update local data with database data
		
		// load the user using local data
        //Authenticate user information (email + password)
        let DAO = UserDAO()
        let authFlag = DAO.userAuthentication(email: self.Email!.text!, password: self.Password!.text!)
		let userInfo: [String]
        if (authFlag != "-1") {
			do {
            userInfo = try DAO.fetchUserInfoFromLocalDB(userId: authFlag)
			
            //Todo: initialize user data
           // let user_id = userInfo[0]
           // let userAuthSuccess = UserData(username: userInfo[1], password: userInfo[2], email: userInfo[3], id: 0)
            
            // Set up task manager
            // TaskManager.sharedTaskManager.setUp(new: user, setting: )
            
            // Bring up rootViewController
            self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
			} catch RuntimeError.DBError(let errorMessage) {
				print(errorMessage)			// consider put the message on UI
			} catch RuntimeError.InternalError(let errorMessage) {
				print(errorMessage)			// consider put the message on UI
			} catch {
				print("Unexpected Error!")  // consider put the message on UI
			}
        }
        else {
            print("Authentication fails")   // Put this message on UI
        }
		
	}
	// This function handles everything that needs to be set up once for this UI.
	// This function is called only after the UIViewController is loaded and never again.
	override func viewDidLoad() {
		super.viewDidLoad()
        
        //Initialize local database
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbPath = documentsPath + "/appData.sqlite"
        var dbpointer: OpaquePointer? = nil
        
        if sqlite3_open(dbPath, &dbpointer) == SQLITE_OK {
            //UserData table
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS UserData" +
                "(user_id TEXT PRIMARY KEY, user_name TEXT, password TEXT, email TEXT, last_update TEXT)", nil, nil, nil)
            //TaskData table not yet implemented
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS TaskData" +
                "(task_id INTEGER PRIMARY KEY, placeholder TEXT)", nil, nil, nil)
            //SettingData table not yet implemented
            sqlite3_exec(dbpointer, "CREATE TABLE IF NOT EXISTS SettingData" +
                "(setting_id INTEGER PRIMARY KEY, placeholder TEXT)", nil, nil, nil)
            print(dbPath)
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

