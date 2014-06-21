//
//  PromiseTests.swift
//  Future
//
//  Created by Maxim Zaks on 20.06.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

import XCTest
import Future

class PromiseTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_promise() {
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        
        var promise = Promise({ Result.Value(23)
        })
        
        promise.fulfill({
            println("\($0)")
            XCTAssert($0 == 23)
            })
        
        promise.fulfill({
            println("\($0)")
            XCTAssert($0 == 23)
            expectation1.fulfill();
            })
        
        waitForExpectationsWithTimeout(5, handler: nil);
    }

}
