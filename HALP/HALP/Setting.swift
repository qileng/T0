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
	private let settingID: Int64?
	
	// Foreign key for this object in database
	private let userID: Int64
	
	// Setting fields.
	// TODO: come up with more personal settings
	// TODO: When adding new fields, define it as private var and provide a default value.
	//	Add it as a optional paramter in the main initializer with a default value. Then add a getter
	//	and a setter.
	private var notificationOn: Bool = true
	private var defaultView: View = .clock
	private var theme: Int64 = 0
	
	// Main Initializer.
	// Everything is option except userID. Setting should not be created without a user.
	init(setting sid: Int64 = 0, user uid: Int64, notification n: Bool = true, theme t: Int64 = 0, defaultView v: View = .clock) {
		self.userID = uid
		self.settingID = (sid == 0) ? IDGenerator.generateID(name: String(uid), type: .setting) : sid
		self.notificationOn = n
		self.theme = t
		self.defaultView = v
	}
	
	// Empty Initializer
	init() {
		self.userID = 0
		self.settingID = nil
	}
	
	// Alternative initializer. Same fashion as the convenience initializer in UserData.
	convenience init(_ disk: Bool) {
		// TODO
		self.init()
	}
	
	// Copy initializer.
	init (_ origin: Setting) {
		self.userID = origin.getUserID()
		self.settingID = origin.getSettingID()
		self.notificationOn = origin.isNotificationOn()
		self.defaultView = origin.getDefaultView()
		self.theme = origin.getTheme()
	}
	
	// Getters
	func isNotificationOn() -> (Bool) {
		return self.notificationOn
	}

	func getSettingID() -> (Int64) {
		return self.settingID!
	}
	
	func getUserID() -> (Int64) {
		return self.userID
	}
	
	func getDefaultView() -> (View) {
		return self.defaultView
	}
	
	func getTheme() -> Int64 {
		return self.theme
	}
	
	// Setters
	func toggleNotification() {
		self.notificationOn = !self.notificationOn
	}

	func setDefaultView(_ v: View) {
		self.defaultView = v
	}
	
	func setTheme(_ t: Int64) {
		self.theme = t
	}
}
