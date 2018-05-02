//
//  UserData.swift
//  HALP
//
//  Created by Qihao Leng on 5/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

class UserData {
	
	// Everything is constant to avoid any potential problem
	private let Username: String
	private let Password: String
	private let Guest: Bool
	
	// Initializer
	init (username: String, password:String) {
		self.Username = username
		self.Password = password
		self.Guest = (Username == "GUEST") ? true : false
	}
	
	// Alternative Initializer
	// Used in case of changing password
	init (origin: UserData, password:String) {
		self.Username = origin.getUsername()
		self.Password = password
		self.Guest = false 	// Guest would never need changing password
	}
	
	// Getters
	func getUsername() -> String{
		return self.Username
	}
	
	func getPassword() -> String{
		return self.Password
	}
	
	func isGuest() -> Bool {
		return Guest
	}
}
