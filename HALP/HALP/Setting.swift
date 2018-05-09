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

enum View: String{
	case clock = "clock"
	case list = "view"
}

class Setting {
	
	// Primary key for this object in database
	private let settingID: UInt64?
	
	// Foreign key for this object in database
	private let userID: UInt64
	
	// Setting fields.
	// TODO: come up with more personal settings
	// TODO: When adding new fields, define it as private var and provide a default value.
	//	Add it as a optional paramter in the main initializer with a default value. Then add a getter
	//	and a setter.
	private var notificationOn: Bool = true
	private var suggestionOn: Bool = true
	private var fontSize: Int = 12
	private var defaultView: View = .clock
	
	// Main Initializer.
	// Everything is option except userID. Setting should not be created without a user.
	init(setting sid: UInt64 = 0, user uid: UInt64, notification n: Bool = true, suggestion s: Bool = true, fontSize f: Int = 12, defaultView v: View = .clock) {
		self.userID = uid
		self.settingID = (sid == 0) ? IDGenerator.generateID(name: String(uid), type: .setting) : sid
		self.notificationOn = n
		self.suggestionOn = s
		self.fontSize = f
		self.defaultView = v
	}
	
	// Empty Initializer
	init() {
		self.userID = 0
		self.settingID = nil
	}
	
	// Alternative initializer. Same fashion as the convenience initializer in UserData.
	convenience init(_ disk: Bool) {
		let DAO = SettingDAO()
		let data = (disk) ? DAO.readFromDisk() : DAO.readFromDatabase()
		self.init(setting: UInt64(data[0])!, user: UInt64(data[1])!, notification: Bool(data[2])!, suggestion: Bool(data[3])!, fontSize: Int(data[4])!, defaultView: View(rawValue: data[5])!)
	}
	
	// Copy initializer.
	init (_ origin: Setting) {
		self.userID = origin.getUserID()
		self.settingID = origin.getSettingID()
		self.notificationOn = origin.isNotificationOn()
		self.suggestionOn = origin.isSuggestionOn()
		self.defaultView = origin.getDefaultView()
		self.fontSize = origin.getFontSize()
	}
	
	// Getters
	func isNotificationOn() -> (Bool) {
		return self.notificationOn
	}
	
	func isSuggestionOn() -> (Bool) {
		return self.suggestionOn
	}
	
	func getSettingID() -> (UInt64) {
		return self.settingID!
	}
	
	func getUserID() -> (UInt64) {
		return self.userID
	}
	
	func getFontSize() -> (Int) {
		return self.fontSize
	}
	
	func getDefaultView() -> (View) {
		return self.defaultView
	}
	
	// Setters
	func toggleNotification() {
		self.notificationOn = !self.notificationOn
	}
	
	func toggleSuggestion() {
		self.suggestionOn = !self.suggestionOn
	}
	
	func setFontSize(_ size: Int) {
		self.fontSize = size
	}
	
	func setDefaultView(_ v: View) {
		self.defaultView = v
	}
}
