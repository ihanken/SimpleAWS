//
//  2NyteDynamoDB.swift
//  2Nyte
//
//  Created by Ian Hanken on 12/13/16.
//  Copyright © 2016 Ian Hanken. All rights reserved.
//

import Foundation
import AWSDynamoDB

public class Dynamo {
    
    public static let shared = Dynamo()
    
    private init() {} // This prevents others from using the default '()' initializer.
    
    var mapper: AWSDynamoDBObjectMapper? = nil
    
    // Set up the mapper so DynamoDB can be used.
    public func initializeDB() {
        mapper = AWSDynamoDBObjectMapper.default()
    }
    
    // MARK: - Type Aliases, closures, and closure functions
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
    
    public func save(_ object: AWSDynamoDBObjectModel) -> Self {
        print("Attempting to save.")
        mapper?.save(object).continue({(task: AWSTask!) -> AnyObject! in
            print("In Save closure")
            
            if task.error != nil {
                print("DynamoDBSaveError: \(task.error!)")
                print(task.error!)
                
                self.doFailure(params: task)
                
            }
            else {
                print(task.result!)
                
                self.doSuccess(params: task)
            }
            
            return nil
            
        })
        
        return self
    }
    
}
