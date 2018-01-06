//
//  QuizNetworkTests.swift
//  QuizTests
//
//  Created by Perry Davies on 25/09/2017.
//  Copyright © 2017 Perry Davies. All rights reserved.
//

import XCTest
@testable import Quiz

class QuizNetworkTests: XCTestCase {
    
    
    /*
     NetworkApi creation shows that we have obtained a single
     reference to the NetworkApi.
     Test results
     Test Case '-[QuizTests.QuizNetworkTests testNetworkApiCreation]' started.
     >>>>>> 0x000060000001b820
     >>>>>> 0x000060000001b820
     Test Case '-[QuizTests.QuizNetworkTests testNetworkApiCreation]' passed (0.009 seconds).
     */
    func testNetworkApiCreation() {
        let firstInstance = NetworkApi.sharedInstance
        
        print(">>>>>> \(Unmanaged<AnyObject>.passUnretained(firstInstance as AnyObject).toOpaque())")
        let secondInstance = NetworkApi.sharedInstance
        print(">>>>>> \(Unmanaged<AnyObject>.passUnretained(secondInstance as AnyObject).toOpaque())")
    }
    
    /*
     isConnected shows that we can reach an outside network
     Initially not created, but then added to show it working.
     Conditions: connected to wi-fi
     Test Results
     Test Case '-[QuizTests.QuizNetworkTests testNetworkApiConnectionWifi]' passed (0.009 seconds).
     */
    func testNetworkApiConnectionWifi() {
        let network = NetworkApi.sharedInstance
        XCTAssert(network.isConnectedToNetwork())
        
    }
    
    /*
     isConnected shows that we can reach an outside network
     Initially not created, but then added to show it working.
     Conditions: not connected to wi-fi
     Test Results
     Test Case '-[QuizTests.QuizNetworkTests testNetworkApiConnectionNoWiFi]' failed (0.013 seconds).
     */
    func testNetworkApiConnectionNoWiFi() {
        let network = NetworkApi.sharedInstance
        XCTAssert(network.isConnectedToNetwork())
        
    }
    
    
}
