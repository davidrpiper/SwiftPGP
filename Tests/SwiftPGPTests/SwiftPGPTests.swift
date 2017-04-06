import XCTest
@testable import SwiftPGP

class SwiftPGPTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(SwiftPGP().text, "Hello, World!")
    }


    static var allTests : [(String, (SwiftPGPTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
