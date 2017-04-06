//
//  GlobalOptionsTests.swift
//  SwiftPGP
//
//  Created by David Piper on 2/4/17.
//


import XCTest
@testable import SwiftPGP

class GlobalOptionsTests: XCTestCase {
    
    func testDefaultValues() {
        XCTAssertEqual(GlobalOptions.isLittleEndian, Int(littleEndian: 42) == 42)
        XCTAssertEqual(GlobalOptions.serializeHeaderFormat, .New)
    }
    
    static var allTests : [(String, (GlobalOptionsTests) -> () throws -> Void)] {
        return [
            ("testDefaultValues", testDefaultValues),
        ]
    }
}
