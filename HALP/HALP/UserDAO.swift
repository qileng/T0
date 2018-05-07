//
//  UserDAO.swift
//  HALP
//
//  Created by Qihao Leng on 5/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//


// TODO: Add more imports here to perform IO with database
import Foundation

// Runtime Errors
enum IOError: Error {
	case runtimeError(String)
}

let SEPERATOR = " "

// This class is used in Data Management layer.
// This class handles all file/databse IO involving user information.
// This class has its properties, Initializers, and Getters inherited from UserData.

final class UserDAO: UserData {

	// The following imlementation is the simplest file IO serving as a verification of functionality. No encoding, no protection, no privacy whatsoever.
	// TODO: Improvements needed.
	
	// This is a call that returns "Documents/" in our App path
	let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
	lazy var file = documentsPath + "/userdata.txt"
	
	// Handles output
	func writeToDisk() {
		do {
			// combine all data fields
			let data = self.getUsername() + SEPERATOR +
					   self.getPassword() + SEPERATOR +
					   self.getUserEmail() + SEPERATOR +
					   String(self.getUserID())
			// write to file
			try data.write(toFile: file, atomically: true, encoding: .utf8)
		}
		catch {
			 print("Write failed\n")
		}
	}
	
	// Handles input
	func readFromDisk() -> [String] {
		do {
			// read from file
			let data = try String(contentsOfFile: file, encoding: .utf8)
			// split string
			let fields = data.split(separator: SEPERATOR[SEPERATOR.startIndex], maxSplits: 3, omittingEmptySubsequences: true)
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
	
	// TODO
	func readFromDatabase() -> [String] {
		return []
	}
	
	// TODO
	func writeToDatabase() {
	}
}

