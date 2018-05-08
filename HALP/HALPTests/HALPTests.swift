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
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    class class1 {
        private var p:Int;
        var l:Int;
        init() {
            self.p = 10;
            self.l = 20;
        }
        func getP ()->(Int) {
            return self.p;
        }
        
    }
    class class2:class1 {
        override init() {
            super.init();
        }
        func getParent() ->Int{
            return super.getP();
        }
    }
    func testTask () {
        let c1:class2 = class2();
        print("    \(c1.getParent())")
    }
    
}
