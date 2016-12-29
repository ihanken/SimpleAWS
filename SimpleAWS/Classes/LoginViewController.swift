//
//  LoginViewController.swift
//  Pods
//
//  Created by Ian Hanken on Wednesday, December 28, 2016.
//
//

import UIKit
import AWSCognitoIdentityProvider

class LoginViewController: UIViewController, AWSCognitoIdentityPasswordAuthentication {
    func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
        
    }
    
    func didCompleteStepWithError(_ error: Error?) {
        
    }
}
