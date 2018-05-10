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
	// This is a call that returns "Documents/" in our App path
    // Initialize path for local database (Built-in SQLite)

    // PLEASE ENCODE ALL DATA IN UTF-8 OR YOU WILL GET GARBLED DATABASE ENTRIES!!!
	// Save new user data to the local database
    // Return true for success, false otherwise
	func saveUserInfoToLocalDB() -> Bool{
            let userId = self.getUserID()
            let username = self.getUsername() as NSString
            let password = self.getPassword() as NSString
            let email = self.getUserEmail() as NSString
            let last_update = Date().timeIntervalSince1970
        
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
            sqlite3_bind_int64(stmt, 1, userId)
            sqlite3_bind_text(stmt, 2, username.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, password.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 4, email.utf8String, -1, nil)
            sqlite3_bind_int(stmt, 5, Int32(last_update))
        
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
    
    // Fetch user data from the local database, use userId as key.
    // Return user info in an array, empty array if query fails.
	// To avoid returning empty array and cause potential runtime error, this function instead throws
	// an error from RuntimeError Enumerator.
    func fetchUserInfoFromLocalDB(userId: Int64 = -1 ) throws -> [Any] {
        if( userId == -1 ) {
            throw RuntimeError.InternalError("fetch() called without key!")
        }
        
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        //Establish database connection
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
			throw RuntimeError.DBError("Local DB does not exist!")
        }
        //SQL command for fecting a row from database base on id
        let selectQueryString = "SELECT * FROM UserData WHERE user_id=" + String(userId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [Any]()
        
        //Traverse through the specific row
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let username = String(cString: sqlite3_column_text(stmt, 1))
            let password = String(cString: sqlite3_column_text(stmt, 2))
            let email = String(cString: sqlite3_column_text(stmt, 3))
            let last_update = sqlite3_column_int(stmt, 4)
            queryResult.append(id)
            queryResult.append(username)
            queryResult.append(password)
            queryResult.append(email)
            queryResult.append(last_update)
        }
        return queryResult
    }
    
    // login authentication function, taking username and password as input
    // Return corresponding user_id if success, "-1" otherwise
    func userAuthentication(email: String, password: String ) -> Int64 {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
        var dbpointer: OpaquePointer?
        
        //Establish database connection
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish database connection")
            return -1
        }
        let emailString = email.split(separator: "@")
        if emailString.count != 2 {
            return -1
        }
    
        //SQL command for fecting a row from database base on id
        var selectQueryString = "SELECT user_id, email FROM UserData WHERE password=\'" + password + "\' AND " +
            "email LIKE " + "\'%" + emailString[0] + "%\'"
        selectQueryString = selectQueryString + " AND " + "email LIKE " + "\'%" + emailString[1] + "%\'"

        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        //Query the specific usermane + password combination
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = sqlite3_column_int64(stmt, 0)
            let email_verify = String(cString: sqlite3_column_text(stmt, 1))
            
            if(email == email_verify) {
                return id
            }
            return -1
        }
            return -1
    }
    
    
    //Email address should be unique
    //This function query the database to maksure that user do not signup with duplicated email
    //Take two parameters: the input email and boolean flag for querying online or local database
    //Return true if the input email is valid(no duplicate), false otherwise
    func validateUserEmailOnline(email: String, onlineDB: Bool) -> Bool {
        if(onlineDB) {
            // TODO
            return true
        }
        else {
            let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/appData.sqlite"
            var dbpointer: OpaquePointer?
            
            //Establish database connection
            if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
                print("fail to establish database connection")
                return false
            }
            let emailString = email.split(separator: "@")
            if emailString.count != 2 {
                return false
            }
            
            //SQL command for fecting a row from database base on id
            var selectQueryString = "SELECT user_id, email FROM UserData WHERE email LIKE " + "\'%" + emailString[0] + "%\'"
            selectQueryString = selectQueryString + " AND " + "email LIKE " + "\'%" + emailString[1] + "%\'"
            
            var stmt: OpaquePointer?
            sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
            if sqlite3_step(stmt) == SQLITE_ROW {
                return false
            }
            return true
        }
    }
	
	// TODO
	func readFromDatabase() -> [String] {
		return []
	}
	
	// TODO
	func writeToDatabase() {
	}
}

