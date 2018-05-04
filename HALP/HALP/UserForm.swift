//
//  UserForm.swift
//  HALP
//
//  Created by Qihao Leng on 5/3/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

class UserForm: UserData {
	
	static let NUMBERS = CharacterSet(charactersIn: "0123456789")
	static let LETTERS_LOWER = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
	static let LETTERS_UPPER = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
	static let SPECIAL = CharacterSet(charactersIn: "!@#$%^./")
	
	static let LEGALPW = NUMBERS.union(LETTERS_LOWER.union(LETTERS_UPPER.union(SPECIAL)))
	static let LEGALUN = NUMBERS.union(LETTERS_LOWER.union(LETTERS_UPPER))
	
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
		
		if substrings.count != 2 {
			return false
		}
		
		let suffix = String(substrings[1])
		if !suffix.contains(".") || suffix.hasSuffix(".") || suffix.hasPrefix(".") {
			return false
		}
		
		return true
	}
}
