//
//  Startup.swift
//  HALP
//
//  Created by Qihao Leng on 4/30/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

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
		let form = UserForm(password: self.Password!.text!, email: self.Email!.text!)
		// TODO: perform login validation
		if !form.onlineValidateExistingUser() {
			return
		}
		
		// TODO: update local data with database data
		
		// load the user using local data
		let user = UserData(true)
		
		// For testing propuse: print user info in shell
		print("Username is: " + user.getUsername())
		print("\nPassword is: " + user.getPassword())
		print("\nEmail is: " + user.getUserEmail())
		print("\nUserID is: " + String(user.getUserID()))
		
		
		// Set up task manager
		// TaskManager.sharedTaskManager.setUp(new: user, setting: )
		
		// Bring up rootViewController
		self.present((self.storyboard?.instantiateViewController(withIdentifier: "RootViewController"))!, animated: true, completion: nil)
	}
	// This function handles everything that needs to be set up once for this UI.
	// This function is called only after the UIViewController is loaded and never again.
	override func viewDidLoad() {
		super.viewDidLoad()
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

