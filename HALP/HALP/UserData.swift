//
//  UserData.swift
//  HALP
//
//  Created by Qihao Leng on 5/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

// This class is the basic runtime instance containing necessary user information.
// This class is also the parent class of UserDAO and UserForm.
// This class is in Business Logic Layer.

class UserData {
	
	// Everything is constant to avoid any potential inconsistency problem.
	private let Username: String?
	private let Password: String?
	private let Guest: Bool?
	private let UserEmail: String?
	// Primary Key
	let UserID: UInt64?
	
	// Empty Initializer.
	init () {
		self.Username = nil
		self.Password = nil
		self.Guest = nil
		self.UserEmail = nil
		self.UserID = nil
	}
	
	// Main Initializer
	// Note:
	//		- username is optional.
	//		- id is also optional.
	//		- A user with username "GUEST" will be identified as a Guest user.
	//
	// Usage:
	// 		- When user login, the caller shall call UserForm(password:email) since user only user
	//		password and email to login. UserForm(password:email) is inherited from this initializer.
	// 		In such case self.Username is never used and self.UserID is never used either.
	//		- When user sign up, the caller shall call UserForm(username:password:email) since user
	//		will provide these three fields except userID. UserForm(username:password:email) is
	//		inherited from this initializer. In such case an id shall be generated.
	//		- Otherwise, the caller shall call UserData(username:password:email:id). E.g. The
	//		convenience initializer of this class calls this initializer with all parameters.
	init (username: String = "", password: String, email: String, id: UInt64 = 0) {
		self.Username = username
		self.Password = password
		self.Guest = (Username == "GUEST") ? true : false
		self.UserEmail = email
		self.UserID = (id == 0) ? IDGenerator.generateID(name: username, type: .user) : id
	}
	
	// Alternative Initializer
	// Used in case of changing password. Functionality not planned.
	init (_ origin: UserData, _ password:String) {
		self.Username = origin.getUsername()
		self.Password = password
		self.Guest = false 	// Guest would never need changing password
		self.UserEmail = origin.getUserEmail()
		self.UserID = origin.getUserID()
	}
	
	// Alternative Initializer
	// Used when the caller want to create a UserData straight from disk or database.
	// Usage: The caller shall call UserData(true) when reading from disk, or UserData(false) when
	// 	reading from database.
	// TODO: Maybe we should update local data with database data and always load from disk? Need to know more about database communication.
    
    convenience init (_ disk: Bool) {
		let DAO = UserDAO()
		let data = DAO.readFromDatabase()
		self.init(username: data[1], password: data[2], email: data[3], id: UInt64(Int(data[0])!))
	}
 
    
    
	
	// Alternative Initializer (Copy Initializer)
	// Used when the caller needs a UserDAO to write data.
	init (_ origin: UserData) {
		self.Username = origin.getUsername()
		self.Password = origin.getUsername()
		self.Guest = origin.isGuest()
		self.UserEmail = origin.getUserEmail()
		self.UserID = origin.getUserID()
	}
	
	// Getters
	func getUsername() -> String{
		return self.Username!
	}
	
	func getPassword() -> String{
		return self.Password!
	}
	
	func isGuest() -> Bool {
		return Guest!
	}
	
	func  getUserEmail() -> String {
		return self.UserEmail!
	}
	
	func getUserID() -> UInt64 {
		return self.UserID!
	}
	
}
