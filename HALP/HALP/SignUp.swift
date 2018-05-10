//
//  SignUp.swift
//  HALP
//
//  Created by Qihao Leng on 5/3/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import UIKit


class SignUpViewController: UIViewController {
	
	@IBOutlet weak var Message: UILabel!
	@IBOutlet weak var password: UITextField!
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var email: UITextField!
	@IBAction func submit(_ sender: UIButton) {
		let form = UserForm(username: username.text!, password: password.text!, email: email.text!)
		if !form.validatePassword() {
			self.Message!.text = "Illegal password!\nPlease try again"
			return
		}
		
		if !form.validateUsername() {
			self.Message!.text = "Illegal username!\nPlease try again"
			return
		}
		
		if !form.validateEmail() {
			self.Message!.text = "Illegal email!\nPlease try again"
			return
		}
		
		// write to local database
		let _DAO = UserDAO(username: form.getUsername(), password: form.getPassword(), email: form.getUserEmail(), id: form.getUserID())
        
        if(!_DAO.saveUserInfoToLocalDB()) {
            self.Message!.text = "Unexpected Error :("
        }
        else {
            self.Message!.text = "Succeeded!"
            let storyBoard = self.storyboard
            let nextViewController = storyBoard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
            self.present(nextViewController, animated: true, completion: nil)
        }
	}
	
    @IBAction func Cancel(_ sender: Any) {
        let storyBoard = self.storyboard
        let nextViewController = storyBoard?.instantiateViewController(withIdentifier: "StartupViewController") as! StartupViewController
        self.present(nextViewController, animated: true, completion: nil)
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

