//
//  UserForm.swift
//  HALP
//
//  Created by Qihao Leng on 5/3/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

// This class is used in User Interface layer.
// This class handles all user input.
// This class has its properties, Initializers, and Getters inherited from UserData.

class UserForm: UserData {
	
	// The following implementation is based on these basic assumptions:
	// 		- Username can only contain numbers and letters
	//		- Password can only contain numbers, letters, and a limited number of special characters.
	//		- Email is in the format of "xx@xx.xx"
	// TODO: Improvements needed.
	
	// Constants represents legal characters.
	static let NUMBERS = CharacterSet(charactersIn: "0123456789")
	static let LETTERS_LOWER = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
	static let LETTERS_UPPER = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
	static let SPECIAL = CharacterSet(charactersIn: "!@#$%^./")
	static let LEGALPW = NUMBERS.union(LETTERS_LOWER.union(LETTERS_UPPER.union(SPECIAL)))
	static let LEGALUN = NUMBERS.union(LETTERS_LOWER.union(LETTERS_UPPER))
    
    func confirmPassword(password: String) -> Bool {
        if self.getPassword() == password {
            return true
        }
        return false
    }
    
	func validatePassword() -> Bool {
		
		// Check password length
		if self.getPassword().count < 8 || self.getPassword().count > 16 {
			print("illegal length\n")
			return false
		}
		
		// Validate password for illegal character
		var isLegal = true
		self.getPassword().forEach { char in
			if !UserForm.LEGALPW.contains(char.unicodeScalars.first!) {
				print("illegal char \(char)\n")
				isLegal = false
			}
		}
		
		return isLegal
	}
	
	func validateUsername() -> Bool {
		
		// Check username length
		if self.getUsername().count > 16 {
			return false
		}
		
		// Check reserved usernames, i.e. "GUEST"
		if self.getUsername() == "GUEST" {
			return false
		}
		
		// Validate username for illegal character
		var isLegal = true
		self.getUsername().forEach { char in
			if !UserForm.LEGALUN.contains(char.unicodeScalars.first!) {
				isLegal = false
			}
		}
		
		return isLegal
	}
	
	func validateEmail() -> Bool {
		
		// Look for "xxx@xxx.xxx"
		// First split it by "@"
		let email = self.getUserEmail()
		
		let substrings = email.split(separator: "@", maxSplits: 2, omittingEmptySubsequences: true)
		
		// Should be separated into "xxx" and "xxx.xxx".
		if substrings.count != 2 {
			return false
		}
		
		// Examine "xxx.xxx"
		// "." must exist AND must not be the first character AND must not be the last character.
		let suffix = String(substrings[1])
		if !suffix.contains(".") || suffix.hasSuffix(".") || suffix.hasPrefix(".") {
			return false
		}
		
		return true
	}
	
	func onlineValidateNewUser() ->  Bool {
		// TODO: Validate new user with database, i.e. check for duplicate userID
		return true
	}
	
    func onlineValidateExistingUser(completion: @escaping (Int64) -> Void) {
		// TODO: Validate existing user with database, i.e. check login credentials
        let userDAO =  UserDAO()
        var userId: Int64 = -1
        userDAO.userAuthentication(email: self.getUserEmail(), password: self.getPassword(), authFlag: { (authFlag) in
            if authFlag != -1 {
                userId = authFlag
            } else {
                userId = -1
            }
            completion(authFlag)
        })
	}
}
