//
//  FutureTests.swift
//  FutureTests
//
//  Created by Maxim Zaks on 16.06.14.
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

import XCTest
import Future

class FutureTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_fulFilled_future() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        var f = future {
            FutureResult.Result(23)
        }
        f (handler: FutureHandler.FulFilled {
            result in
            println("Promise fulfilled : \(result)")
            XCTAssert(result == 23)
            expectation1.fulfill();
        })
        
        waitForExpectationsWithTimeout(2, handler: nil);
    }
    
    func test_fulFilled_future_with_sleep() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        var f = future {
            () -> FutureResult<Int> in
            sleep(2)
            println("done waiting")
            return FutureResult.Result(23)
        }
        println("---------------------------------")
        f (handler: FutureHandler.FulFilled {
            result in
            println("Promise fulfilled : \(result)")
            XCTAssert(result == 23)
            expectation1.fulfill();
            })
        
        waitForExpectationsWithTimeout(3, handler: nil);
    }
    
    func test_fulFilled_two_future_with_sleep() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        let expectation2 = expectationWithDescription("Should Wait for future 2");
        var f1 = future {
            () -> FutureResult<Int> in
            sleep(2)
            println("done waiting")
            return FutureResult.Result(23)
        }
        println("---------------------------------")
        var f2 = future {
            () -> FutureResult<Int> in
            sleep(2)
            println("done waiting")
            return FutureResult.Result(45)
        }
        f1 (handler: FutureHandler.FulFilled {
            result in
            println("Promise fulfilled : \(result)")
            XCTAssert(result == 23)
            expectation1.fulfill();
            })
        f2 (handler: FutureHandler.FulFilled {
            result in
            println("Promise fulfilled 2: \(result)")
            XCTAssert(result == 45)
            expectation2.fulfill();
            })
        
        waitForExpectationsWithTimeout(3, handler: nil);
    }
    
    func test_fulFilled_two_times_on_the_same_future() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        let expectation2 = expectationWithDescription("Should Wait for future 2");
        var f = future {
            FutureResult.Result(23)
        }
        f (handler: FutureHandler.FulFilled {
            result in
            println("Promise fulfilled : \(result)")
            XCTAssert(result == 23)
            expectation1.fulfill();
            })
        
        f (handler : FutureHandler.FulFilled {
            result in
            println("Promise fulfilled 2: \(result)")
            XCTAssert(result == 23)
            expectation2.fulfill();
            })
        
        waitForExpectationsWithTimeout(2, handler: nil);
    }
    
    func test_failed_future() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        
        let error = NSError(domain: "Future failed", code: 567, userInfo: nil)
        
        var f = future {
            FutureResult<Int>.Error(error)
        }
        f (handler: FutureHandler.Failed {
            error in
            println("Promise failed : \(error)")
            XCTAssertNotNil(error)
            expectation1.fulfill();
            })
        
        waitForExpectationsWithTimeout(2, handler: nil);
    }
    
    
    func test_function_result() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        
        func add(n1:Int, n2:Int) -> ((handler : FutureHandler<Int>)->()) {
            return future {
                FutureResult.Result(n1+n2)
            }
        }
        
        let sum1 = add(5,7)
        
        sum1 (handler: FutureHandler.FulFilled {
            XCTAssert($0 == 12)
            expectation1.fulfill();
            })
        
        waitForExpectationsWithTimeout(2, handler: nil);
    }
    
    func test_function_result_with_error() {
        // This is an example of a functional test case.
        let expectation1 = expectationWithDescription("Should Wait for future 1");
        
        func add(n1:Int, n2:Int) -> ((handler : FutureHandler<Int>)->()) {
            let error = NSError(domain: "Math", code: 2255, userInfo: nil)
            return future {
                FutureResult.Error(error)
            }
        }
        
        let sum1 = add(5,7)
        
        sum1 (handler: FutureHandler.Failed {
            XCTAssertNotNil($0)
            XCTAssertEqual($0.domain!, "Math", "Unexpected error : \($0)")
            expectation1.fulfill();
            })
        
        waitForExpectationsWithTimeout(2, handler: nil);
    }
}
