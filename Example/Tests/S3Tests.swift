//
//  S3Tests.swift
//  SimpleAWS
//
//  Created by Ian Hanken on Wednesday, January 11, 2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import XCTest
import AWSCore
import AWSS3

@testable import SimpleAWS

class S3Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        S3.shared.initializeS3(region: .usWest2, identityPoolID: "us-west-2:af80910b-3da5-4866-b343-f61e7f50f173", bucketName: "simpleawsbucket")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    func uploadImage() {
        let expectation = self.expectation(description: "Success closure entered.")
        
        // Create a black image.
        if let blackImage = UIImage(color: .black) {
            if let data = UIImageJPEGRepresentation(blackImage, 0.8) {
                let fileName = getDocumentsDirectory().appendingPathComponent("test.jpg")
                try? data.write(to: fileName)
                
                S3.shared.upload(key: "test.jpg", imagePath: fileName).onFailure { task in
                    print("Test Image Upload failed.")
                }.onSuccess { task in
                    expectation.fulfill()
                    print("Image uploaded successfully")
                }
            }
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func downloadImage() {
        let expectation = self.expectation(description: "Success closure entered.")
        
        S3.shared.download(key: "test.jpg", downloadPath: getDocumentsDirectory().appendingPathComponent("test.jpg")).onFailure { task in
            print("Test image download failed")
        }.onSuccess { task in
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testImageUploadAndDownload() {
        uploadImage()
        downloadImage()
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
