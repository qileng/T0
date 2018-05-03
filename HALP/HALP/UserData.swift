//
//  UserData.swift
//  HALP
//
//  Created by Qihao Leng on 5/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

/* This class is the basic implementation of User.
*/

class UserData {
	
	// Everything is constant to avoid any potential problem
	private let Username: String
	private let Password: String
	private let Guest: Bool
	private let UserEmail: String
	private let UserID: UInt32					// Big enough
	
	// A UserDAO object that handles data access
	var DAO: UserDAO? = nil
	
	// Initializer
	init (_ username: String, _ password: String, _ email: String) {
		self.Username = username
		self.Password = password
		self.Guest = (Username == "GUEST") ? true : false
		self.UserEmail = email
		self.UserID = UserData.generateID()
		self.DAO = UserDAO(self)
	}
	
	// Alternative Initializer
	// Used in case of changing password
	init (_ origin: UserData, _ password:String) {
		self.Username = origin.getUsername()
		self.Password = password
		self.Guest = false 	// Guest would never need changing password
		self.UserEmail = origin.getUserEmail()
		self.UserID = origin.getUserID()
		self.DAO = UserDAO(self)
	}
	
	// Copy Initializer
	init (_ origin: UserData) {
		self.Username = origin.getUsername()
		self.Password = origin.getUsername()
		self.Guest = origin.isGuest()
		self.UserEmail = origin.getUserEmail()
		self.UserID = origin.getUserID()
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
	
	func  getUserEmail() -> String {
		return self.UserEmail
	}
	
	func getUserID() -> UInt32 {
		return self.UserID
	}
	
	// Generator for ID
	static func generateID() -> UInt32 {
		// TODO
		return 0
	}
}
