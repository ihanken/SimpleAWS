//
//  S3.swift
//  Pods
//
//  Created by Ian Hanken on Wednesday, January 11, 2017.
//
//

import Foundation
import AWSS3

public class S3 {
    
    public static let shared = S3()
    
    private init() {} // This prevents others from using the default '()' initializer.
    
    private var S3BucketName: String = ""
    private var manager: AWSS3TransferManager? = nil
    
    public func initializeS3(region: AWSRegionType, identityPoolID: String, bucketName: String) {
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType: region, identityPoolId: identityPoolID)
        let configuration = AWSServiceConfiguration(region: region, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        S3BucketName = bucketName
        manager = AWSS3TransferManager.default()
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
    
    public func download(key: String, downloadPath: URL) -> Self {
        let downloadRequest = AWSS3TransferManagerDownloadRequest()
        
        downloadRequest?.bucket = S3BucketName
        downloadRequest?.key = key
        downloadRequest?.downloadingFileURL = downloadPath
        
        
        manager?.download(downloadRequest!).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task)
            return nil
        }
        
        return self
    }
    
    public func upload(key: String, imagePath: URL) -> Self {
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.key = key
        uploadRequest?.body = imagePath
        
        manager?.upload(uploadRequest!).continueWith { (task: AWSTask!) -> AnyObject! in
            self.handleBlock(task: task)
            return nil
        }
        
        return self
    }
}
