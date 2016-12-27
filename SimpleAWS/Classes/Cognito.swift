//
//  Pool.swift
//  PasscodeLock
//
//  Created by Ian Hanken on 7/21/16.
//  Copyright © 2016 Yanko Dimitrov. All rights reserved.
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
    
    internal var userPool: AWSCognitoIdentityUserPool? = nil
    
    internal var user: AWSCognitoIdentityUser? = nil
    
    // Method to set the email when a PasscodeLock is created.
    
    public func setEmail(email: String) {
        print("Setting email to \(email)")
        
        userEmail = email
        
        print("Setting user to \(userPool?.getUser(email))")
        
        user = userPool?.getUser(email)
        
        // Set the default email so a user can login from app opening.
        print("Setting default email to \(email)")
        
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
        print("Pool set up.")
    }
    // Type aliases for AWSCognitoIdentyProvider Tasks.
    /**
    typealias SignUpResponse = AWSTask<AWSCognitoIdentityUserPoolSignUpResponse>
    typealias LogInResponse = AWSTask<AWSCognitoIdentityUserSession>
    typealias ConfirmationResponse = AWSTask<AWSCognitoIdentityUserConfirmSignUpResponse>
    typealias ChangePasswordResponse = AWSTask<AWSCognitoIdentityUserChangePasswordResponse>
    typealias ForgottenPasswordResponse = AWSTask<AWSCognitoIdentityUserForgotPasswordResponse>
    typealias ForgottenPasswordConfirmationResponse = AWSTask<AWSCognitoIdentityUserConfirmForgotPasswordResponse>
    typealias VerifyAttributeResponse = AWSTask<AWSCognitoIdentityUserVerifyAttributeResponse>
    typealias UserDetailsResponse = AWSTask<AWSCognitoIdentityUserGetDetailsResponse>
    typealias DeleteUserResponse = AWSTask<AnyObject>
    */
    
    // MARK: - Test Aliases
    public typealias Response = (AWSTask<AnyObject>) -> ()
    public var success: Response?
    public var failure: Response?
    
    public func onSuccess(closure: @escaping Response) {
        success = closure
    }
    
    public func onFailure(closure: @escaping Response) -> Self {
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
    
    // Type aliases, variables and functions handling sign ups.
    /**
    typealias SignUpClosure = (SignUpResponse) -> ()
    
    var signUpSuccessClosure: SignUpClosure?
    var signUpFailureClosure: SignUpClosure?
    
    func onSignUpSuccess(closure: @escaping SignUpClosure) {
        signUpSuccessClosure = closure
    }
    
    func onSignUpFailure(closure: @escaping SignUpClosure) -> Self {
        signUpFailureClosure = closure
        return self
    }
    
    func doSignUpSuccess(params: SignUpResponse) {
        if let closure = signUpSuccessClosure {
            closure(params)
        }
    }
    
    func doSignUpFailure(params: SignUpResponse) {
        if let closure = signUpFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling log ins.
    
    typealias LogInClosure = (LogInResponse) -> Void
    
    var logInSuccessClosure: ((LogInResponse) -> ())?
    var logInFailureClosure: ((LogInResponse) -> ())?
    
    func onLogInSuccess(closure: @escaping ((LogInResponse) -> ())) {
        logInSuccessClosure = closure
    }
    
    func onLogInFailure(closure: @escaping ((LogInResponse) -> ())) -> Self {
        logInFailureClosure = closure
        return self
    }
    
    func doLogInSuccess(params: LogInResponse) {
        if let closure = logInSuccessClosure {
            closure(params)
        }
    }
    
    func doLogInFailure(params: LogInResponse) {
        if let closure = logInFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling account confirmations.
    
    typealias ConfirmationClosure = (ConfirmationResponse) -> Void
    
    var confirmationSuccessClosure: ((ConfirmationResponse) -> ())?
    var confirmationFailureClosure: ((ConfirmationResponse) -> ())?
    
    func onConfirmationSuccess(closure: @escaping ((ConfirmationResponse) -> ())) {
        confirmationSuccessClosure = closure
    }
    
    func onConfirmationFailure(closure: @escaping ((ConfirmationResponse) -> ())) -> Self {
        confirmationFailureClosure = closure
        return self
    }
    
    func doConfirmationSuccess(params: ConfirmationResponse) {
        if let closure = confirmationSuccessClosure {
            closure(params)
        }
    }
    
    func doConfirmationFailure(params: ConfirmationResponse) {
        if let closure = confirmationFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling password changes.
    
    typealias ChangePasswordClosure = (ChangePasswordResponse) -> Void
    
    var changePasswordSuccessClosure: ((ChangePasswordResponse) -> ())?
    var changePasswordFailureClosure: ((ChangePasswordResponse) -> ())?
    
    func onChangePasswordSuccess(closure: @escaping ((ChangePasswordResponse) -> ())) {
        changePasswordSuccessClosure = closure
    }
    
    func onChangePasswordFailure(closure: @escaping ((ChangePasswordResponse) -> ())) -> Self {
        changePasswordFailureClosure = closure
        return self
    }
    
    func doChangePasswordSuccess(params: ChangePasswordResponse) {
        if let closure = changePasswordSuccessClosure {
            closure(params)
        }
    }
    
    func doChangePasswordFailure(params: ChangePasswordResponse) {
        if let closure = changePasswordFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling forgotten passwords.
    
    typealias ForgottenPasswordClosure = (ForgottenPasswordResponse) -> Void
    
    var forgottenPasswordSuccessClosure: ((ForgottenPasswordResponse) -> ())?
    var forgottenPasswordFailureClosure: ((ForgottenPasswordResponse) -> ())?
    
    func onForgottenPasswordSuccess(closure: @escaping ((ForgottenPasswordResponse) -> ())) {
        forgottenPasswordSuccessClosure = closure
    }
    
    func onForgottenPasswordFailure(closure: @escaping ((ForgottenPasswordResponse) -> ())) -> Self {
        forgottenPasswordFailureClosure = closure
        return self
    }
    
    func doForgottenPasswordSuccess(params: ForgottenPasswordResponse) {
        if let closure = forgottenPasswordSuccessClosure {
            closure(params)
        }
    }
    
    func doForgottenPasswordFailure(params: ForgottenPasswordResponse) {
        if let closure = forgottenPasswordFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling forgotten passwords.
    
    typealias ForgottenPasswordConfirmationClosure = (ForgottenPasswordConfirmationResponse) -> Void
    
    var forgottenPasswordConfirmationSuccessClosure: ((ForgottenPasswordConfirmationResponse) -> ())?
    var forgottenPasswordConfirmationFailureClosure: ((ForgottenPasswordConfirmationResponse) -> ())?
    
    func onForgottenPasswordConfirmationSuccess(closure: @escaping ((ForgottenPasswordConfirmationResponse) -> ())) {
        forgottenPasswordConfirmationSuccessClosure = closure
    }
    
    func onForgottenPasswordConfirmationFailure(closure: @escaping ((ForgottenPasswordConfirmationResponse) -> ())) -> Self {
        forgottenPasswordConfirmationFailureClosure = closure
        return self
    }
    
    func doForgottenPasswordConfirmationSuccess(params: ForgottenPasswordConfirmationResponse) {
        if let closure = forgottenPasswordConfirmationSuccessClosure {
            closure(params)
        }
    }
    
    func doForgottenPasswordConfirmationFailure(params: ForgottenPasswordConfirmationResponse) {
        if let closure = forgottenPasswordConfirmationFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling attribute verification.
    
    typealias VerifyAttributeConfirmationClosure = (VerifyAttributeResponse) -> Void
    
    var verifyAttributeSuccessClosure: ((VerifyAttributeResponse) -> ())?
    var verifyAttributeFailureClosure: ((VerifyAttributeResponse) -> ())?
    
    func onVerifyAttributeSuccess(closure: @escaping ((VerifyAttributeResponse) -> ())) {
        verifyAttributeSuccessClosure = closure
    }
    
    func onVerifyAttributeFailure(closure: @escaping ((VerifyAttributeResponse) -> ())) -> Self {
        verifyAttributeFailureClosure = closure
        return self
    }
    
    func doVerifyAttributeSuccess(params: VerifyAttributeResponse) {
        if let closure = verifyAttributeSuccessClosure {
            closure(params)
        }
    }
    
    func doVerifyAttributeFailure(params: VerifyAttributeResponse) {
        if let closure = verifyAttributeFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling user details responses.
    
    typealias UserDetailsClosure = (UserDetailsResponse) -> Void
    
    var userDetailsSuccessClosure: ((UserDetailsResponse) -> ())?
    var userDetailsFailureClosure: ((UserDetailsResponse) -> ())?
    
    func onUserDetailsSuccess(closure: @escaping ((UserDetailsResponse) -> ())) {
        userDetailsSuccessClosure = closure
    }
    
    func onUserDetailsFailure(closure: @escaping ((UserDetailsResponse) -> ())) -> Self {
        userDetailsFailureClosure = closure
        return self
    }
    
    func doUserDetailsSuccess(params: UserDetailsResponse) {
        if let closure = userDetailsSuccessClosure {
            closure(params)
        }
    }
    
    func doUserDetailsFailure(params: UserDetailsResponse) {
        if let closure = userDetailsFailureClosure {
            closure(params)
        }
    }
    
    // Type aliases, variables and functions handling user details responses.
    
    typealias DeleteUserClosure = (DeleteUserResponse) -> Void
    
    var deleteUserSuccessClosure: ((DeleteUserResponse) -> ())?
    var deleteUserFailureClosure: ((DeleteUserResponse) -> ())?
    
    func onDeleteUserSuccess(closure: @escaping ((DeleteUserResponse) -> ())) {
        deleteUserSuccessClosure = closure
    }
    
    func onDeleteUserFailure(closure: @escaping ((DeleteUserResponse) -> ())) -> Self {
        deleteUserFailureClosure = closure
        return self
    }
    
    func doDeleteUserSuccess(params: DeleteUserResponse) {
        if let closure = deleteUserSuccessClosure {
            closure(params)
        }
    }
    
    func doDeleteUserFailure(params: DeleteUserResponse) {
        if let closure = deleteUserFailureClosure {
            closure(params)
        }
    }
    **/
    
    // AWSCognitoIdentityProvider authentication methods.
    public func signUp(userPassword: String) -> Self {
        
        let email = AWSCognitoIdentityUserAttributeType()
        email?.name = "email"
        email?.value = userEmail!
        
        // Sign the user up.
        userPool?.signUp(email!.value!, password: userPassword, userAttributes: [email!], validationData: nil).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in            
            if task.error != nil {
                print(task.error!)
                print("Trying failure")
                self.doFailure(params: task as! AWSTask<AnyObject>)
            }
            else {
                print(task.result!)
                print("Trying success")
                self.doSuccess(params: task as! AWSTask<AnyObject>)
                
                self.user = self.userPool?.getUser(self.userEmail!)
            }
            
            return nil
        })
        
        print("Done signing up.")
        
        return self
    }
    
    // Log the user in.
    public func logIn(userPassword: String) -> Self {
        
        user?.getSession(userEmail!, password: userPassword, validationData: nil).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    // Confirm the user's email.
    public func confirm(confirmationString: String) -> Self {
        
        user?.confirmSignUp(confirmationString).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    public func forgotPassword() -> Self {
        print(user?.getDetails() ?? "No details found for user.")
        
        user?.forgotPassword().continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    public func confirmForgotPassword(confirmationString: String, passcode: String) -> Self {
        
        user?.confirmForgotPassword(confirmationString, password: passcode).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    public func changePassword(currentPassword: String, proposedPassword: String) -> Self {
        
        user?.changePassword(currentPassword, proposedPassword: proposedPassword).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    public func verifyUserAtrribute(attribute: String, code: String) -> Self {
        user?.verifyAttribute(attribute, code: code).continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    public func getUserDetails() -> Self {
        user?.getDetails().continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
    
    public func deleteUser() -> Self {
        user?.delete().continue(with: AWSExecutor.mainThread(), with: {(task: AWSTask!) -> AnyObject! in
            
            if task.error != nil {
                print(task.error!)
                
                self.doFailure(params: task as! AWSTask<AnyObject>)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task as! AWSTask<AnyObject>)
            }
            
            return nil
        })
        
        return self
    }
}
