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
            let alert = UIAlertController(title: "Illegal password!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
			return
		}
		
		if !form.validateUsername() {
            let alert = UIAlertController(title: "Illegal usernmae!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
			return
		}
		
		if !form.validateEmail() {
            let alert = UIAlertController(title: "Illegal email!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
			return
		}
		
		// write to local database
		let _DAO = UserDAO(username: form.getUsername(), password: form.getPassword(), email: form.getUserEmail(), id: form.getUserID())
        // check databse for duplicate email address
        if(!_DAO.validateUserEmailOnline(email: form.getUserEmail(), onlineDB: false)) {
            let alert = UIAlertController(title: "Email already taken!", message: "Please try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        else {
            if(!_DAO.saveUserInfoToLocalDB()) {
                let alert = UIAlertController(title: "Unexpected Error :(", message: "Cannnot establish database connection", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
            else {
                let alert = UIAlertController(title: "Success!", message: "You can now sign in with your account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {(action) -> Void in
                    self.present((self.storyboard?.instantiateViewController(withIdentifier: "StartupViewController"))!, animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
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

