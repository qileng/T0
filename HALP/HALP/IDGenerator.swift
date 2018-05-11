//
//  IDGenerator.swift
//  HALP
//
//  Created by Qihao Leng on 5/8/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import Foundation

enum IDType: Int {
	case user = 0
	case setting = 1
	case task = 2
}

// This is a helper struct used to generate ID for all three data classes we have.
// The ID generated is determined by three factors:
//		- The main identifier: username, task title, for Setting it's the userID as String.
//		- The type of data classes.
//		- The current time.
//
// Algorithm Overview:
//		- The ID generated shall have a hex format of 0x1234567890abc.
//		- The first 4 hex digits are determined by the main identifier.
//		- The fifth hex digit is determined by the type.
//		- The last 8 digits are determined by the current time.
//
// Detail:
//		- The simpleStringHash() calculate a weak hash value for a 16-digit string. In particular,
//		it follows the latex formula $\sum_{i=0}^{15} i\times s[i]$. It is not strong, but it will
//		suffice to be an extra factor besides timestamp.
//		- The type digit is simply 0 for user, 1 for setting, 2 for task.
//		- The timestamp shall serve as a main factor. It takes the unix epoch timestamp as a UInt32,
//		which results in a 8-digit hex. The max value of UInt32 is 0xffffffff, which, as a epoch
//		timestamp, results in a date in year 2106.
//		- Lastly, we take the hash, shift it left by 36 bits, which is equivalent to time it by 16^9.
//		Then take the type, shift it left by 32 bits, which is equivalent to time it by 16^8.
//		Then add the timestamp to it. Collision happens if and only if two ID are generated exactly
//		within the same second and their main identifier collides in terms of hash.

struct IDGenerator {
	static func generateID(name s: String, type t: IDType) -> (Int64) {
		// Get current timestamp. UInt32.max represents a time somewhere in year 2106.
		let current = Date()
		let timestamp = (UInt32)(current.timeIntervalSince1970)
		let prefix = IDGenerator.simpleStringHash(s)
		let ID = (Int64(prefix) << 36) + (Int64(t.rawValue) << 32) + Int64(timestamp)
	
		// Debug output
		print("Prefix is: 0x" + String(prefix, radix:16))
		print("Type is: 0x" + String(t.rawValue, radix:16))
		print("Timestamp is: 0x" + String(timestamp, radix:16))
		print("ID is: 0x" + String(ID, radix:16))
		
		return ID
	}
	
	// Simple hash of 16-digit Strings. Note that hash has an upper bound of 0x40d0.
	static func simpleStringHash(_ s: String) -> UInt32 {
		var hash: UInt32 = 0
		if s.isEmpty {
			// Adds some protection. Happens during authentication, in which ID is not used.
			return 0xffff
		}
		let temp = s as NSString
		for index in 0...(s.count-1) {
			// iterate over the String
			hash = hash + (UInt32)(index+1)*UInt32(temp.character(at: index))
		}
		return hash
	}
}
