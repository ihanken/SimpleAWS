//
//  Dynamo.swift
//  SimpleAWS
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
    public func initializeDB(region: AWSRegionType, identityPoolID: String) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: identityPoolID)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        mapper = AWSDynamoDBObjectMapper.default()
    }
    
    // MARK: - Type Aliases, closures, and closure functions
    public typealias Response = (AWSTask<AnyObject>) -> ()
    
    public var success: Response?
    public var failure: Response?
    
    public func onSuccess(closure: Response?) {
        success = closure
    }
    
    public func onFailure(closure: Response?) -> Self {
        failure = closure
        return self
    }
    
    public func doSuccess(params: AWSTask<AnyObject>) {
        if let closure = success { closure(params) }
    }
    
    public func doFailure(params: AWSTask<AnyObject>) {
        if let closure = failure { closure(params) }
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
    
    // Load an object from the table.
    public func load(objectClass: AnyClass, hashKey: Any, rangeKey: Any?) -> Self {
        mapper?.load(objectClass, hashKey: hashKey, rangeKey: rangeKey).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task)
            return nil
        }
        
        return self
    }
    
    // Scan the table.
    public func scan(objectClass: AnyClass, expression: AWSDynamoDBScanExpression) -> Self {
        mapper?.scan(objectClass, expression: expression).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        }
        
        return self
    }
    
    // Query the table
    public func query(objectClass: AnyClass, expression: AWSDynamoDBQueryExpression) -> Self {
        mapper?.query(objectClass, expression: expression).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        }
        
        return self
    }
    
    // Item update.
    public func update(input: AWSDynamoDBUpdateItemInput) -> Self {
        AWSDynamoDB.default().updateItem(input).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        }
        
        return self
    }
    
    // Batch write item.
    public func batchWrite(item: AWSDynamoDBBatchWriteItemInput) -> Self {
        AWSDynamoDB.default().batchWriteItem(item).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task as! AWSTask<AnyObject>)
            return nil
        }
        
        return self
    }
    
    // Save an object to the table.
    public func save(object: AWSDynamoDBObjectModel) -> Self {
        mapper?.save(object).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task)
            return nil
        }
        
        return self
    }
    
    // Delete an object from the table.
    public func delete(object: AWSDynamoDBObjectModel) -> Self {
        mapper?.remove(object).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task)
            return nil
        }
        
        return self
    }
    
}
