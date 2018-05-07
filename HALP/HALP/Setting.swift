//
//  Setting.swift
//  HALP
//
//  Created by Qihao Leng on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

// This class is the basic runtime instance containing necessary setting information.
// This class is also the parent class of SettingDAO and SettingForm.
// This class is in Business Logic Layer.

class Setting {
	
	// Primary key for this object in database
	private let settingID: UInt32?
	
	// Foreign key for this object in database
	private let userID: UInt32?
	
	// Setting fields. TODO: come up with more personal settings
	private var notificationOn = true
	private var suggestionOn = true
	
	// Initializer
	init(setting sid: UInt32, user uid: UInt32, notification: Bool, suggestion: Bool) {
		self.userID = uid
		self.settingID = sid
		self.notificationOn = notification
		self.suggestionOn = suggestion
	}
	
	// Empty Initializer
	init() {
		self.userID = nil
		self.settingID = nil
	}
	
	// Alternative initializer. Same fashion as the convenience initializer in UserData.
	convenience init(_ disk: Bool) {
		let DAO = SettingDAO()
		let data = (disk) ? DAO.readFromDisk() : DAO.readFromDatabase()
		self.init(setting: UInt32(data[0])!, user: UInt32(data[1])!, notification: Bool(data[2])!, suggestion: Bool(data[3])!)
	}
	
	// Copy initializer.
	init (_ origin: Setting) {
		self.userID = origin.getUserID()
		self.settingID = origin.getSettingID()
		self.notificationOn = origin.isNotificationOn()
		self.suggestionOn = origin.isSuggestionOn()
	}
	
	// Getters
	func isNotificationOn() -> (Bool) {
		return self.notificationOn
	}
	
	func isSuggestionOn() -> (Bool) {
		return self.suggestionOn
	}
	
	func getSettingID() -> (UInt32) {
		return self.settingID!
	}
	
	func getUserID() -> (UInt32) {
		return self.userID!
	}
	
	// Setters
	func toggleNotification() {
		self.notificationOn = !self.notificationOn
	}
	
	func toggleSuggestion() {
		self.suggestionOn = !self.suggestionOn
	}
	
	// TODO: Generate an ID. Necessity unknown.
	static func generateID() -> (UInt32) {
		return 0
	}
}
