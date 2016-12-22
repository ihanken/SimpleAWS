import UIKit
import XCTest

@testable import SimpleAWS

class DynamoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Cognito.shared.setUserPool(region: .usWest2, identityPoolID: "us-west-2:af80910b-3da5-4866-b343-f61e7f50f173", credentialsProvider: nil, clientID: "36afdes56mqbqjnr3df8j6ig23", clientSecret: "1kf2j32773vr6gsd89m490jlf8fap0nmr3bujfebl9sfrh035d9q", poolID: "us-west-2_JERl4z5ck")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDBInitialization() {
        Dynamo.shared.initializeDB()
        XCTAssert(Dynamo.shared.mapper != nil)
    }
    
    
}
