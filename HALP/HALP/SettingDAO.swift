//
//  SettingDAO.swift
//  HALP
//
//  Created by Qihao Leng on 5/7/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

final class SettingDAO: Setting {
	let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
	lazy var file = documentsPath + "/settingdata.txt"
	
	func readFromDisk() -> [String] {
		do {
			// read from file
			let data = try String(contentsOfFile: file, encoding: .utf8)
			// split string
			let fields = data.split(separator: SEPERATOR[SEPERATOR.startIndex], maxSplits: 5, omittingEmptySubsequences: true)
			var fieldString: [String] = []
			for field in fields {
				fieldString.append(String(field))
			}
			return fieldString
		}
		catch {
			print("Read failed\n")
		}
		return []
	}

	
	func readFromDatabase() -> [String] {
		return []
	}
	
	func writeToDatabase() {
	
	}
}

