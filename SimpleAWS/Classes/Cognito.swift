//
//  Cognito.swift
//  SimpleAWS
//
//  Created by Ian Hanken on 7/21/16.
//  Copyright © 2016 Ian Hanken. All rights reserved.
//

import Foundation
import AWSCognito
import AWSCognitoIdentityProvider

/* MARK: - Constants */
let AWS_EMAIL_KEY = "awsEmailKey"

public class Cognito {
    // Make class usable as a singleton This is so we can set a delegate for the user pool and maintain it.
    public static let shared = Cognito()
    
    private init() {} // This prevents others from using the default '()' initializer.
    
    // Email and user objects necessary for the AWS methods.
    private var userEmail: String? = nil
    public var userPool: AWSCognitoIdentityUserPool? = nil
    private var user: AWSCognitoIdentityUser? = nil
    
    // Method to set the email when a PasscodeLock is created.
    public func setEmail(email: String) {
        userEmail = email
        user = userPool?.getUser(email)
        
        // Set the default email so a user can login from app opening.
        UserDefaults.standard.set(email, forKey: AWS_EMAIL_KEY)
        UserDefaults.standard.synchronize()
    }
    
    // Method to set the userPool in AppDelegate.
    
    public func setUserPool(region: AWSRegionType, identityPoolID: String, credentialsProvider: AWSCredentialsProvider?, clientID: String, clientSecret: String?, poolID: String) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: identityPoolID)
        let serviceConfiguration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
        
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: clientID, clientSecret: clientSecret, poolId: poolID)
        
        AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: userPoolConfiguration, forKey: "UserPool")
        
        self.userPool = AWSCognitoIdentityUserPool(forKey: "UserPool")
    }
    
    // MARK: - Type Aliases, closures, and closure functions
    public typealias Response = (AWSTask<AnyObject>) -> ()
    
    public var success: Response?
    public var failure: Response?
    
    public func onSuccess(closure: @escaping Response) {
        success = closure
    }
    
    public func onFailure(closure: @escaping Response) -> Self {
        print("Changing failure closure.")
        failure = closure
        return self
    }
    
    public func doSuccess(params: AWSTask<AnyObject>) {
        if let closure = success {
            closure(params)
        }
    }
    
    public func doFailure(params: AWSTask<AnyObject>) {
        if let closure = failure {
            closure(params)
        }
    }
    
    public func handleBlock(task: AWSTask<AnyObject>) {
        if task.error != nil {
            print(task.error!)
            
            self.doFailure(params: task)
        }
        else {
            print(task.result!)
            
            self.doSuccess(params: task)
        }
    }
    
    // AWSCognitoIdentityProvider authentication methods.
    public func signUp(username: String, password: String, attributes: Dictionary<String, String>) -> Self {
        
        var attributeArray = [AWSCognitoIdentityUserAttributeType]()
        
        // Transfer everything from the dictionary into the attribute array so it can be used in the sign up process.
        for (key, value) in attributes { attributeArray.append(AWSCognitoIdentityUserAttributeType(name: key, value: value)) }
        
        // Sign the user up.
        userPool?.signUp(username, password: password, userAttributes: attributeArray, validationData: nil).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
            }
            else {
                print(task.result!)
                
                self.user = self.userPool?.getUser(username)
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    // Log the user in.
    public func logIn(userPassword: String) -> Self {
        user?.getSession(userEmail!, password: userPassword, validationData: nil).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Confirm a user..
    public func confirm(confirmationString: String) -> Self {
        user?.confirmSignUp(confirmationString).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Send a request for a forgotten password code to be sent to the user's email.
    public func forgotPassword() -> Self {
        user?.forgotPassword().continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Confirm that the user that requested a password reset is the correct user.
    public func confirmForgotPassword(confirmationString: String, passcode: String) -> Self {
        user?.confirmForgotPassword(confirmationString, password: passcode).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Change the current user's password.
    public func changePassword(currentPassword: String, proposedPassword: String) -> Self {
        user?.changePassword(currentPassword, proposedPassword: proposedPassword).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Verify a given user attribute.
    public func verifyUserAtrribute(attribute: String, code: String) -> Self {
        user?.verifyAttribute(attribute, code: code).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Get details of the current user.
    public func getUserDetails() -> Self {
        user?.getDetails().continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
    
    // Delete the current user.
    public func deleteUser() -> Self {
        print(user?.getDetails())
        user?.delete().continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            print("Inside delete.")
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        })
        
        return self
    }
}
