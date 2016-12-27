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
    
    public func initializeDB() {
        
        mapper = AWSDynamoDBObjectMapper.default()
    }
    
    //MARK: - SaveRequest type aliases, closures, and functions.
    
    typealias SaveRequestClosure = (AnyObject!) -> Void
    
    var saveRequestSuccessClosure: ((AnyObject?) -> ())?
    var saveRequestFailureClosure: ((AnyObject?) -> ())?
    
    public func onSaveRequestSuccess(closure: @escaping ((AnyObject?) -> ())) {
        saveRequestSuccessClosure = closure
    }
    
    public func onSaveRequestFailure(closure: @escaping ((AnyObject?) -> ())) -> Self {
        saveRequestFailureClosure = closure
        return self
    }
    
    public func doSaveRequestSuccess(params: AnyObject?) {
        if let closure = saveRequestSuccessClosure {
            closure(params)
        }
    }
    
    public func doSaveRequestFailure(params: AnyObject?) {
        if let closure = saveRequestFailureClosure {
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
                
                self.doSaveRequestFailure(params: task)
                
            }
            else {
                print(task.result!)
                
                self.doSaveRequestSuccess(params: task)
            }
            
            return nil
            
        })
        
        return self
    }
    
}
