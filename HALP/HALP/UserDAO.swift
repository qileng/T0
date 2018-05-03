//
//  UserDAO.swift
//  HALP
//
//  Created by Qihao Leng on 5/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//


// TODO: Add more imports here to perform IO with database
import Foundation


final class UserDAO: UserData {

	
	// All initializers are inherited from UserData
	
	// Getters are not necessary
	
	// This class should handle IO
	// TODO
	// The following is the simplest file IO
	let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
	lazy var file = documentsPath + "test.txt"

	func writeToDisk() {
		do {
			try self.getUsername().write(toFile: file, atomically: false, encoding: .utf8)
		}
		catch {
			 print("Write failed\n")
		}
		
		do {
			let username = try String(contentsOfFile: file, encoding: .utf8)
			print(username)
		}
		catch {
			print("Read failed\n")
		}
	}
}

