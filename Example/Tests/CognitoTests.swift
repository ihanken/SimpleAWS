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
import AWSCognitoIdentityProvider

@testable import SimpleAWS

class CognitoTests: XCTestCase, AWSCognitoIdentityInteractiveAuthenticationDelegate {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Cognito.shared.setUserPool(region: .usWest2, identityPoolID: "us-west-2:af80910b-3da5-4866-b343-f61e7f50f173", credentialsProvider: nil, clientID: "36afdes56mqbqjnr3df8j6ig23", clientSecret: "1kf2j32773vr6gsd89m490jlf8fap0nmr3bujfebl9sfrh035d9q", poolID: "us-west-2_JERl4z5ck")
        
        Cognito.shared.setEmail(email: "ihanken@bellsouth.net")
        
        Cognito.shared.userPool?.delegate = self
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        UserDefaults.standard.set(nil, forKey: AWS_EMAIL_KEY)
    }
    
    func testEmailSetting() {
        XCTAssert(UserDefaults.standard.value(forKey: AWS_EMAIL_KEY) != nil)
    }
    
    func testSignUp() {
        let attributeDict: Dictionary<String, String> = [
            "email": "ihanken@bellsouth.net"
        ]
        
        let expectation = self.expectation(description: "Success closure entered.")
        
        Cognito.shared.signUp(username: "ihanken@bellsouth.net", password: "tE5tP@ss", attributes: attributeDict).onFailure {_ in 
            print("Failed to sign up user.")
        }.onSuccess {_ in 
            print("Successfully signed up user.")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
        return LoginViewController()
    }
}
