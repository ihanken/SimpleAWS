//
//  CognitoTests.swift
//  SimpleAWS
//
//  Created by Ian Hanken on Thursday, December 22, 2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
import AWSCore

@testable import SimpleAWS

class CognitoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        UserDefaults.standard.set(nil, forKey: AWS_EMAIL_KEY)
    }
    
    func testEmailSetting() {
        Cognito.shared.setEmail(email: "test@email.com")
        XCTAssert(UserDefaults.standard.value(forKey: AWS_EMAIL_KEY) != nil)
    }
}
