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

var db = "/appData.sqlite"					// Global variable indicates which database to use.


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
        
            let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
            var dbpointer: OpaquePointer?
        
            //Establish database connection
            if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
                print("fail to establish database connection")
				sqlite3_close(dbpointer)
                return false
            }
        
            //SQL command for inserting new row into database
            let insertQueryString = "INSERT INTO UserData (user_id, user_name, password, email, last_update) VALUES (?, ?, ?, ?, ?)"
        
            //statement for binding values into insert statement
            var stmt: OpaquePointer?
            sqlite3_prepare(dbpointer, insertQueryString, -1, &stmt, nil)
            sqlite3_bind_int64(stmt, 1, userId)
            sqlite3_bind_text(stmt, 2, username.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, password.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 4, email.utf8String, -1, nil)
            sqlite3_bind_int(stmt, 5, Int32(last_update))
        
            //The operation returns SQLITE_DONE, which is an int success
            //See SQLite result codes for detail
            if sqlite3_step(stmt) == SQLITE_DONE {
                sqlite3_close(dbpointer)
                return true
            } else {
                let errmsg = String(cString: sqlite3_errmsg(dbpointer)!)
                print(errmsg)
                sqlite3_close(dbpointer)
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
        
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        //Establish database connection
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
			sqlite3_close(dbpointer)
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
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return queryResult
    }
    
    // login authentication function, taking username and password as input
    // Return corresponding user_id if success, "-1" otherwise
    func userAuthentication(email: String, password: String ) -> Int64 {
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        //Establish database connection
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish database connection")
			sqlite3_close(dbpointer)
            return -1
        }
        let emailString = email.split(separator: "@")
        if emailString.count != 2 {
            sqlite3_close(dbpointer)
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
                sqlite3_finalize(stmt)
                sqlite3_close(dbpointer)
                return id
            }
            sqlite3_finalize(stmt)
            sqlite3_close(dbpointer)
            return -1
        }
            sqlite3_finalize(stmt)
            sqlite3_close(dbpointer)
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
            let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
            var dbpointer: OpaquePointer?
            
            //Establish database connection
            if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
                print("fail to establish database connection")
				sqlite3_close(dbpointer)
                return false
            }
            let emailString = email.split(separator: "@")
            if emailString.count != 2 {
				sqlite3_close(dbpointer)
                return false
            }
            
            //SQL command for fecting a row from database base on id
            var selectQueryString = "SELECT email FROM UserData WHERE email LIKE " + "\'%" + emailString[0] + "%\'"
            selectQueryString = selectQueryString + " AND " + "email LIKE " + "\'%" + emailString[1] + "%\'"
            
            var stmt: OpaquePointer?
            sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
            //Check if the email address exists
            while sqlite3_step(stmt) == SQLITE_ROW {
                let email_verify = String(cString: sqlite3_column_text(stmt, 0))
                
                if(email == email_verify) {
                    //Finialize statement to prevent database from locking
                    sqlite3_finalize(stmt)
                    sqlite3_close(dbpointer)
                    return false
                }
            }
            sqlite3_finalize(stmt)
            sqlite3_close(dbpointer)
            return true
        }
    }
	
    func updateUserInfoInLocalDB(userId: Int64, username: String? = nil, password: String? = nil, email: String? = nil) -> Bool {
        // Default local database path
        let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
        var dbpointer: OpaquePointer?
        
        if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
            print("fail to establish databse connection")
            sqlite3_close(dbpointer)
            return false
        }
        
        var argumentManager = [String]()
        
        var usernameQueryString = ""
        if username != nil {
            usernameQueryString = " user_name = ?,"
            argumentManager.append(username! + "`txt")
        }
        
        var passwordQueryString = ""
        if password != nil {
            passwordQueryString = " password = ?,"
            argumentManager.append(password! + "`txt")
        }
        
        var emailQueryString = ""
        if email != nil {
            emailQueryString = " email = ?,"
            argumentManager.append(email! + "`txt")
        }
        
        // last_update will always be updated
        let lastUpdateQueryString = " last_update = ?"
        
        let updateQueryString = "UPDATE UserData SET" + usernameQueryString + passwordQueryString
            + emailQueryString + lastUpdateQueryString + " WHERE user_id=" + String(userId)
        
        var stmt: OpaquePointer?
        if sqlite3_prepare(dbpointer, updateQueryString, -1, &stmt, nil) != SQLITE_OK {
            print("cannot prepare statements")
            sqlite3_close(dbpointer)
            return false
        }
        
        // Initialize sql statement
        if(argumentManager.count > 0) {
            for index in 0...argumentManager.count-1 {
                var infoAndType = argumentManager[index].split(separator: "`")
                // Array index starts at 0
                // Binding index starts at 1
                if infoAndType[1] == "txt" {
                    sqlite3_bind_text(stmt, Int32(index + 1), (infoAndType[0] as NSString).utf8String, -1, nil)
                }
            }
        }
        
        // Bind the last argument
        let lastIndex = argumentManager.count + 1
        sqlite3_bind_int(stmt, Int32(lastIndex), Int32(Date().timeIntervalSince1970))
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            sqlite3_finalize(stmt)
            sqlite3_close(dbpointer)
            return false
        }
        sqlite3_finalize(stmt)
        sqlite3_close(dbpointer)
        return true
    }
}

