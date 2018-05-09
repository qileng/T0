//
//  UserDAO.swift
//  HALP
//
//  Created by Qihao Leng on 5/2/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//


// TODO: Add more imports here to perform IO with database
import Foundation
import SQLite3

let SEPERATOR = " "

// This class is used in Data Management layer.
// This class handles all file/databse IO involving user information.
// This class has its properties, Initializers, and Getters inherited from UserData.

final class UserDAO: UserData {

	// The following imlementation is the simplest file IO serving as a verification of functionality. No encoding, no protection, no privacy whatsoever.
	// TODO: Improvements needed.
	
	// This is a call that returns "Documents/" in our App path
    // Initialize path for local database (Built-in SQLite)
    /*
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
 */
    
    //PLEASE ENCODE ALL DATA IN UTF-8 OR YOU WILL GET GARBLED DATABASE ENTRIES!!!
	// Save new user data to the local database
    //Return true for success, false otherwise
	func saveUserInfoToLocalDB() -> Bool{
            let userId = self.getUserID()
            let username = self.getUsername() as NSString
            let password = self.getPassword() as NSString
            let email = self.getUserEmail() as NSString
            //Placeholder for last_update
            let last_update = "" as NSString
        
            let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
            var dbpointer: OpaquePointer?
        
            //Establish database connection
            if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
                print("fail to establish database connection")
                return false
            }
        
            //SQL command for inserting new row into database
            let insertQueryString = "INSERT INTO UserData (user_id, user_name, password, email, last_update) VALUES (?, ?, ?, ?, ?)"
        
            //statement for binding values into insert statement
            var stmt: OpaquePointer?
            sqlite3_prepare(dbpointer, insertQueryString, -1, &stmt, nil)
            //Store as string for now, uint64 cannot be cast into int64
            sqlite3_bind_text(stmt, 1, String(userId), -1, nil)
            sqlite3_bind_text(stmt, 2, username.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, password.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 4, email.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 5, last_update.utf8String, -1, nil)
        
            //The operation returns SQLITE_DONE, which is an int success
            //See SQLite result codes for detail
            if sqlite3_step(stmt) == SQLITE_DONE {
                return true
            } else {
                let errmsg = String(cString: sqlite3_errmsg(dbpointer)!)
                print(errmsg)
                return false
            }
	}
    
    //Fetch user data from the local database, use userId as key
    //Return user info in an array, empty array if query fails
    func fetchUserInfoFromLocalDB(userId: String = "" ) throws -> [String] {
        if( userId == "" ) {
            throw RuntimeError.InternalError("fetch() called without key!")
        }
        
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        //Establish database connection
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
			throw RuntimeError.DBError("Local DB does not exist!")
        }
        //SQL command for fecting a row from database base on id
        let selectQueryString = "SELECT * FROM UserData WHERE user_id=" + userId
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [String]()
        
        //Traverse through the specific row
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = String(cString: sqlite3_column_text(stmt, 0))
            let username = String(cString: sqlite3_column_text(stmt, 1))
            let password = String(cString: sqlite3_column_text(stmt, 2))
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let last_update = String(cString: sqlite3_column_text(stmt, 4))
            queryResult.append(id)
            queryResult.append(username)
            queryResult.append(password)
            queryResult.append(email)
            queryResult.append(last_update)
        }
        return queryResult
    }
    
    //login authentication function, taking username and password as input
    //Return corresponding user_id if success, "-1" otherwise
    func userAuthentication(email: String, password: String ) -> String {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        //Establish database connection
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish database connection")
            return "-1"
        }
        
        let emailString = email.split(separator: "@")

        //SQL command for fecting a row from database base on id
        let selectQueryString = "SELECT user_id FROM UserData WHERE password=" + password + " AND " + "email LIKE " + "\'%"+emailString[0]+"%\'"
        print(selectQueryString)
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        //Query the specific usermane + password combination
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = String(cString: sqlite3_column_text(stmt, 0))
            return id
        }
        return "-1"
    }
    
    
	/*
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
 */
	
	// TODO
	func readFromDatabase() -> [String] {
		return []
	}
	
	// TODO
	func writeToDatabase() {
	}
}

