//
//  SettingForm.swift
//  HALP
//
//  Created by Qihao Leng on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

final class SettingForm: Setting {
	// Inherits everything. Identical to Setting class but in UI layer. This is just to conform layered architecture.
	// Usage: When user is in setting page, the viewController shall create a SettingForm instance by copying the current Setting instance in TaskManager. After that, the user's actions like toggling UISwitch should be associated with the SettingForm instance. After the system leaves setting page, viewController shall create a new Setting instance by copying the SettingForm instance. Then tell TaskManager to use this new Setting instance.
	func verificateTime() -> Bool {
		return self.getStartTime() < self.getEndTime()
	}
}
