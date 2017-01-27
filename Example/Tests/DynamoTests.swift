import UIKit
import XCTest
import AWSDynamoDB

@testable import SimpleAWS

class DynamoTests: XCTestCase {
    
    var dynamoObject: TestObject? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Cognito.shared.setUserPool(region: .USWest2, identityPoolID: "us-west-2:af80910b-3da5-4866-b343-f61e7f50f173", credentialsProvider: nil, clientID: "36afdes56mqbqjnr3df8j6ig23", clientSecret: "1kf2j32773vr6gsd89m490jlf8fap0nmr3bujfebl9sfrh035d9q", poolID: "us-west-2_JERl4z5ck")
        
        Dynamo.shared.initializeDB(region: .USWest2, identityPoolID: "us-west-2:af80910b-3da5-4866-b343-f61e7f50f173")
        
        dynamoObject = TestObject()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDBInitialization() {
        XCTAssert(Dynamo.shared.mapper != nil)
    }
    
    func testSaveSuccess() {
        let expectation = self.expectation(description: "Success closure entered.")
        
        self.dynamoObject?.id = 1
        self.dynamoObject?.name = "Testing Test"
        self.dynamoObject?.isGirl = false
        
        print(dynamoObject!)
        
        Dynamo.shared.save(object: self.dynamoObject!).onFailure {_ in
            print("Save failed.")
        }.onSuccess {_ in
            expectation.fulfill()
            print("Save succeeded.")
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSaveFailure() {
        let expectation = self.expectation(description: "Failure closure entered.")
        
        Dynamo.shared.save(object: dynamoObject!).onFailure {_ in
            print("Save failed.")
            expectation.fulfill()
        }.onSuccess {_ in 
            print("Save succeeded.")
        }
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}

class TestObject: AWSDynamoDBObjectModel {
    // Title and info you would see in the feed
    var id: Int = -1
    var name: String = ""
    var isGirl: Bool = false
    
    
    override var description: String {
        var str = ""
        
        str += "--- Test Object ---\n" +
            "ID: \(id)\n" +
            "Name: \(name)\n"
        
        if isGirl == true { str += "Gender: Female\n" }
        else { str += "Gender: Male\n" }
        
        return str
        
    }
    
    /* MARK: - Initializers */
    override init!() { super.init() }
    required init!(coder: NSCoder!) { fatalError("init(coder:) has not been implemented") }
    
    class func dynamoDBTableName() -> String! { return "test" }
    class func hashKeyAttribute() -> String! { return "id" }
}

