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
	private let Username: String?
	private let Password: String?
	private let Guest: Bool?
	private let UserEmail: String?
	private let UserID: UInt32?					// Big enough
	
	// A UserDAO object that handles data access
	var DAO: UserDAO? = nil
	
	// Empty Initializer
	init () {
		self.Username = nil
		self.Password = nil
		self.Guest = nil
		self.UserEmail = nil
		self.UserID = nil
	}
	
	// Initializer
	// Note that last parameter is optional. It shall be passed in when UserID already exists.
	init (_ username: String, _ password: String, _ email: String, _ id: UInt32 = 0) {
		self.Username = username
		self.Password = password
		self.Guest = (Username == "GUEST") ? true : false
		self.UserEmail = email
		self.UserID = (id == 0) ? UserData.generateID() : id
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
	
	// Alternative Initializer
	// Used when creating a user and read data from file
	// Call by "UserDATA(true)"
	convenience init (_: Bool, _: Int) {
		let _DAO = UserDAO()
		let data = _DAO.readFromDisk()
		self.init(data[0], data[1], data[2], UInt32(Int(data[3])!))
	}
	
	// Copy Initializer used by UserDAO
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
	
	func getUserID() -> UInt32 {
		return self.UserID!
	}
	
	// Generator for ID
	static func generateID() -> UInt32 {
		// TODO
		return 0
	}
}
