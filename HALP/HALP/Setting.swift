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
	private let settingID: Int64?
	
	// Foreign key for this object in database
	private let userID: Int64
	
	// Setting fields.
	// TODO: come up with more personal settings
	// TODO: When adding new fields, define it as private var and provide a default value.
	//	Add it as a optional paramter in the main initializer with a default value. Then add a getter
	//	and a setter.
	private var notificationOn: Bool = true
	private var summary = "0,0,0,0,0,0,0,0"
	private var defaultSort: SortingType = .time
	private var theme: Theme = .regular
	// By default available 7 days a week. Format: SatFriThuWedTuesMonSun
	private var availableDays: Int32 = 0b1111111
	private var startTime: Int32 = 8						// default start time 8am
	private var endTime: Int32 = 24							// default end time 12am
	
	// Main Initializer.
	// Everything is option except userID. Setting should not be created without a user.
	init(setting sid: Int64 = 0, notification n: Bool = true, theme t: Theme = .regular,
		 summary sum: String = "0,0,0,0,0,0,0,0", defaultSort sort: SortingType = .time , availableDays d: Int32 = 0b1111111, startTime s: Int32 = 8,
		 endTime e: Int32 = 24, user uid: Int64) {
		self.userID = uid
		self.settingID = sid
		self.notificationOn = n
		self.theme = t
		self.summary = sum
		self.defaultSort = sort
		self.startTime = s
		self.availableDays = d
		self.endTime = e
	}
	
	// Empty Initializer
	init() {
		self.userID = 0
		self.settingID = 0
	}
    
    // Default setting initializer for first time user
    init(userId: Int64) {
        self.userID = userId
        self.settingID = userId
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
		self.summary = origin.getSummary()
		self.theme = origin.getTheme()
		self.startTime = origin.getStartTime()
		self.endTime = origin.getEndTime()
		self.availableDays = origin.getAvailableDays()
		self.defaultSort = origin.getDefaultSort()
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
	
	func getSummary() -> (String) {
		return self.summary
	}
	
	func getTheme() -> (Theme) {
		return self.theme
	}
	
	func getAvailableDays() -> Int32 {
		return self.availableDays
	}
	
	func getStartTime() -> Int32 {
		return self.startTime
	}
	
	func getEndTime() -> Int32 {
		return self.endTime
	}
	
	func getDefaultSort() -> SortingType {
		return self.defaultSort
	}
	
	// Setters
	func toggleNotification() {
		self.notificationOn = !self.notificationOn
	}

	func setSummary(_ s: String) {
		self.summary = s
	}
	
	func setTheme(_ t: Theme) {
		self.theme = t
	}
	
	func setAvailableDays(_ d: Int32) {
		self.availableDays = d
	}
	
	func setStartTime(_ t: Int32) {
		self.startTime = t
	}
	
	func setEndTime(_ t: Int32) {
		self.endTime = t
	}
	
	func setDefaultSort(_ s: SortingType) {
		self.defaultSort = s
	}
}
