//
//  HALPTests.swift
//  HALPTests
//
//  Created by Qihao Leng on 4/27/18.
//  Copyright © 2018 Team Zero. All rights reserved.
//

import XCTest
@testable import HALP

class HALPTests: XCTestCase {
	
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testWriteToDisk() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
		
		print("Test 1 Begins")
		let testUser1 = UserData("GUEST", "GUEST", "GUEST@GUEST.com")
		let testDAO = UserDAO(testUser1)
		testDAO.writeToDisk()
    }
	
	func testReadFromDisk() {
		print("Test 2 Begins")
		let testUser2 = UserData(true)
		print(testUser2.getUsername())
		print(testUser2.getPassword())
		print(testUser2.getUserEmail())
		print(testUser2.getUserID())
	}
	
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
