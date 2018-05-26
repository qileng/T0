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
import UIKit

let SEPERATOR = " "

var db = "/HALP.sqlite"					// Global variable indicates which database to use.


// This class is used in Data Management layer.
// This class handles all file/databse IO involving user information.
// This class has its properties, Initializers, and Getters inherited from UserData.

final class UserDAO: UserData {
	// This is a call that returns "Documents/" in our App path
    // Initialize path for local database (Built-in SQLite)

    // PLEASE ENCODE ALL DATA IN UTF-8 OR YOU WILL GET GARBLED DATABASE ENTRIES!!!
	// Save new user data to the local database
    // Return true for success, false otherwise

	func saveUserInfoToLocalDB() -> Bool {
            let userId = String(self.getUserID()) as NSString // change it to string
            print(userId)
            let username = self.getUsername() as NSString
            let password = self.getPassword() as NSString
            let email = self.getUserEmail() as NSString
            let last_update = Date().timeIntervalSince1970
            let dbPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + db
            print(dbPath)
            var dbpointer: OpaquePointer?
            //Establish database connection
            if sqlite3_open(dbPath, &dbpointer) != SQLITE_OK {
                print("fail to establish database connection")
				sqlite3_close(dbpointer)
                return false
            }
        
            //SQL command for inserting new row into database
            let insertQueryString = "INSERT INTO ZMS_User (zid, zusername, zpassword, zemail, zlast_update) VALUES (?, ?, ?, ?, ?)"
        
            //statement for binding values into insert statement
            var stmt: OpaquePointer?
            sqlite3_prepare(dbpointer, insertQueryString, -1, &stmt, nil)
            sqlite3_bind_text(stmt, 1, userId.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 2, username.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 3, password.utf8String, -1, nil)
            sqlite3_bind_text(stmt, 4, email.utf8String, -1, nil)
            sqlite3_bind_int(stmt, 5, Int32(last_update))
        
            //The operation returns SQLITE_DONE, which is an int success
            //See SQLite result codes for detail
            if sqlite3_step(stmt) == SQLITE_DONE {
                sqlite3_close(dbpointer)
                print("save to local database")
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
        let selectQueryString = "SELECT * FROM ZMS_User WHERE zid = " + String(userId)
        
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        
        var queryResult = [Any]()
        
        //Traverse through the specific row
        while sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int64(String(cString: sqlite3_column_text(stmt, 0)))
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
        var selectQueryString = "SELECT zid, zemail FROM ZMS_User WHERE zpassword= '" + password + "' AND zemail = '" + email + "'"
        var stmt: OpaquePointer?
        sqlite3_prepare(dbpointer, selectQueryString, -1, &stmt, nil)
        //Query the specific usermane + password combination
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = String(cString: sqlite3_column_text(stmt, 0)) // change it back to int
            let email_verify = String(cString: sqlite3_column_text(stmt, 1))
            if(email == email_verify) {
                sqlite3_finalize(stmt)
                sqlite3_close(dbpointer)
                return Int64(id)!
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
    
    var client: MSClient?
    var userTable : MSSyncTable?
    var query: MSQuery?
    var predicate: NSPredicate?
    var queryString: NSString?
    var context: MSSyncContext?
    //var res : Operation?
    var store: MSCoreDataStore?
    var result: MSSyncContextReadResult?
    func validateUserEmailOnline(email: String, onlineDB: Bool, delegate: UITextFieldDelegate) -> Bool {
        if(onlineDB)
        {
            // TODO connect to the online database, do the query and return the result
            // always connect to online db for now
            client = MSClient(
                            applicationURLString:"https://halpt0.azurewebsites.net")
            let delegate =  UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext = delegate.managedObjectContext!
            store = MSCoreDataStore(managedObjectContext: managedObjectContext)
            client?.syncContext = MSSyncContext(delegate: nil, dataSource: store, callback: nil)
            let context = client?.syncContext
            let userTable = client!.syncTable(withName: "ZMS_User")
            let predicate = NSPredicate(format: "zemail == % @",email)
            let query = userTable.query(with: predicate)
            // MSSync table is only for pulling and pushing operations only
            // only adding data to the local database
            let res = userTable.pull(with: query, queryId: "AllRecords")
            {
                 (error) in
                 if error != nil {
                    print("pulling error ", error)
                }
            }
        }
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
        var selectQueryString = "SELECT zemail FROM ZMS_User WHERE zemail = " + "'" + email + "'"
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
        // udpate the database with the online database
        return true
    }
    
	
	// TODO
    func fetchFromOnlineDBtoLocalDB(userId: Int64 = -1) -> Bool{
        
        return false
    }
    
    func UpdateOnlineDBFromLocalDB() -> Bool{
        return false
    }
//    func readFromDatabase() -> [String] {
//        return []
//    }
//
//    // TODO
//    func writeToDatabase() {
//    }
}

