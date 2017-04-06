//
//  NewPacketHeaderTests.swift
//  SwiftPGP
//
//  Created by David Piper on 2/4/17.
//

import XCTest
@testable import SwiftPGP

class NewPacketHeaderTests: XCTestCase {
    
    func testPacketHeaderMethods() {
        guard let header = NewPacketHeader(tag: .Marker, length: 3, isPartial: false) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(header.format(), .New)
        XCTAssertEqual(header.packetTag(), .Marker)
        XCTAssertEqual(header.packetType(), .Marker)
        XCTAssertEqual(header.isPartial(), false)
        XCTAssertEqual(header.bodyLength(), UInt32(3))
        XCTAssertEqual(header.oldFormatLengthType(), nil)
    }
    
    // This test is here specifically because NewPacketHeaders should be able to handle
    // the newer Packet Tags, where OldPacketHeaders should not.
    func testHighestTag() {
        let packetHeader = NewPacketHeader(tag: .ModificationDetectionCode,
                                           length: 3,
                                           isPartial: false)
        XCTAssertNotNil(packetHeader)
    }
    
    func testPartialWithMinimumLength() {
        guard let header = NewPacketHeader(tag: .Marker, length: 224, isPartial: true) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(header.isPartial())
        XCTAssertEqual(header.bodyLength(), UInt32(1))
    }
    
    func testPartialWithMaximumLength() {
        guard let header = NewPacketHeader(tag: .Marker, length: 254, isPartial: true) else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(header.isPartial())
        XCTAssertEqual(header.bodyLength(), UInt32(1073741824))
    }
    
    func testPartialWithOneLessThanMinimumLength() {
        let packetHeader = NewPacketHeader(tag: .Marker, length: 223, isPartial: true)
        XCTAssertNil(packetHeader)
    }
    
    func testPartialWithOneMoreThanMaximumLength() {
        let packetHeader = NewPacketHeader(tag: .Marker, length: 255, isPartial: true)
        XCTAssertNil(packetHeader)
    }
    
    func testSerializePartial() {
        
        // Test all possible serializations of a Partial Header
        for i: UInt32 in 224...254 {
            let packetHeader = NewPacketHeader(tag: .Marker, length: i, isPartial: true)
            guard let bytes = packetHeader?.serialize() else {
                XCTFail()
                return
            }
            
            XCTAssertEqual(packetHeader!.bodyLength(), UInt32(1 << UInt32(bytes[1] & 0x1F)))
            
            XCTAssertEqual(bytes.count, 2)
            XCTAssertEqual(bytes[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
            XCTAssertEqual(bytes[1], UInt8(i))
        }
        
    }
    
    func testSerializeFull() {
        
        guard
            let header0 = NewPacketHeader(tag: .Marker, length: 0, isPartial: false)?.serialize(),
            let header191 = NewPacketHeader(tag: .Marker, length: 191, isPartial: false)?.serialize(),
            let header192 = NewPacketHeader(tag: .Marker, length: 192, isPartial: false)?.serialize(),
            let header1337 = NewPacketHeader(tag: .Marker, length: 1337, isPartial: false)?.serialize(),
            let header8383 = NewPacketHeader(tag: .Marker, length: 8383, isPartial: false)?.serialize(),
            let header8384 = NewPacketHeader(tag: .Marker, length: 8384, isPartial: false)?.serialize(),
            let header111111111 = NewPacketHeader(tag: .Marker, length: 111111111, isPartial: false)?.serialize(),
            let header4294967295 = NewPacketHeader(tag: .Marker, length: 4294967295, isPartial: false)?.serialize()
            else {
                XCTFail()
                return
        }
        
        // Packet Tag header + Body Length header
        XCTAssertEqual(header0.count, 1 + 1)
        XCTAssertEqual(header191.count, 1 + 1)
        XCTAssertEqual(header192.count, 1 + 2)
        XCTAssertEqual(header1337.count, 1 + 2)
        XCTAssertEqual(header8383.count, 1 + 2)
        XCTAssertEqual(header8384.count, 1 + 5)
        XCTAssertEqual(header111111111.count, 1 + 5)
        XCTAssertEqual(header4294967295.count, 1 + 5)
        
        // These should all be the same
        XCTAssertEqual(header0[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header191[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header192[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header1337[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header8383[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header8384[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header111111111[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        XCTAssertEqual(header4294967295[0], UInt8(0xC0) + PacketTag.Marker.rawValue)
        
        // Body length headers (RFC 4880, Section 4.2.2.*)
        
        // bodyLen = 1st_octet
        XCTAssertEqual(header0[1], UInt8(0))
        
        XCTAssertEqual(header191[1], UInt8(191))
        
        // bodyLen = ((1st_octet - 192) << 8) + (2nd_octet) + 192
        XCTAssertEqual(header192[1], UInt8(192))
        XCTAssertEqual(header192[2], UInt8(0))
        
        XCTAssertEqual(header1337[1], UInt8(196))
        XCTAssertEqual(header1337[2], UInt8(121))
        
        XCTAssertEqual(header8383[1], UInt8(223))
        XCTAssertEqual(header8383[2], UInt8(255))
        
        // bodyLen = (2nd_octet << 24) | (3rd_octet << 16) | (4th_octet << 8) | 5th_octet
        XCTAssertEqual(header8384[1], UInt8(255))
        XCTAssertEqual(header8384[2], UInt8(0))
        XCTAssertEqual(header8384[3], UInt8(0))
        XCTAssertEqual(header8384[4], UInt8(0x20))
        XCTAssertEqual(header8384[5], UInt8(0xC0))
        
        XCTAssertEqual(header4294967295[1], UInt8(255))
        XCTAssertEqual(header4294967295[2], UInt8(255))
        XCTAssertEqual(header4294967295[3], UInt8(255))
        XCTAssertEqual(header4294967295[4], UInt8(255))
        XCTAssertEqual(header4294967295[5], UInt8(255))
        
        // This one is a check to ensure we got the endianness right in our length calculations
        XCTAssertEqual(header111111111[1], UInt8(255))
        XCTAssertEqual(header111111111[2], UInt8(0x06))
        XCTAssertEqual(header111111111[3], UInt8(0x9F))
        XCTAssertEqual(header111111111[4], UInt8(0x6B))
        XCTAssertEqual(header111111111[5], UInt8(0xC7))
    }
    
    func testDeserializePartial() {
        
        // Success cases
        
        for i: UInt32 in 224...254 {
            guard let serial = NewPacketHeader(tag: .Marker, length: i, isPartial: true)?.serialize() else {
                XCTFail("Serial: \(i)")
                return
            }
            guard let deserial = NewPacketHeader.deserialize(serial) else {
                XCTFail("Derserial: \(i)")
                return
            }
            XCTAssertEqual(deserial.1, 2)
            XCTAssertEqual(deserial.0.isPartial(), true)
            XCTAssertEqual(deserial.0.bodyLength(), UInt32(1 << (i & 0x1F)))
        }
        
        // Failure cases can't happen because they will just be
        // deserialized as non-partial packets
    }
    
    func testDeserializeFull() {
        
        // Test failing deserializations first
        deserializeFullFailureCases()
        
        guard
            let serial0 = NewPacketHeader(tag: .PublicKeyEncryptedSessionKey, length: 0, isPartial: false)?.serialize(),
            let serial191 = NewPacketHeader(tag: .ModificationDetectionCode, length: 191, isPartial: false)?.serialize(),
            let serial192 = NewPacketHeader(tag: .Marker, length: 192, isPartial: false)?.serialize(),
            let serial1337 = NewPacketHeader(tag: .Marker, length: 1337, isPartial: false)?.serialize(),
            let serial8383 = NewPacketHeader(tag: .Marker, length: 8383, isPartial: false)?.serialize(),
            let serial8384 = NewPacketHeader(tag: .Marker, length: 8384, isPartial: false)?.serialize(),
            let serial111111111 = NewPacketHeader(tag: .Marker, length: 111111111, isPartial: false)?.serialize(),
            let serial4294967295 = NewPacketHeader(tag: .Marker, length: 4294967295, isPartial: false)?.serialize()
            else {
                XCTFail()
                return
        }
        
        // Deserialize these individually so it's obvious where the test fails
        
        guard let header0 = NewPacketHeader.deserialize(serial0) else {
            XCTFail()
            return
        }
        
        guard let header191 = NewPacketHeader.deserialize(serial191) else {
            XCTFail()
            return
        }
        
        guard let header192 = NewPacketHeader.deserialize(serial192) else {
            XCTFail()
            return
        }
        
        guard let header1337 = NewPacketHeader.deserialize(serial1337) else {
            XCTFail()
            return
        }
        
        guard let header8383 = NewPacketHeader.deserialize(serial8383) else {
            XCTFail()
            return
        }
        
        guard let header8384 = NewPacketHeader.deserialize(serial8384) else {
            XCTFail()
            return
        }
        
        guard let header111111111 = NewPacketHeader.deserialize(serial111111111) else {
            XCTFail()
            return
        }
        
        guard let header4294967295 = NewPacketHeader.deserialize(serial4294967295) else {
            XCTFail()
            return
        }
        
        guard let headerOneExtra = NewPacketHeader.deserialize(serial4294967295 + [0x00]) else {
            XCTFail()
            return
        }
        
        // Validate numbers of bytes used
        XCTAssertEqual(header0.1, 2)
        XCTAssertEqual(header191.1, 2)
        XCTAssertEqual(header192.1, 3)
        XCTAssertEqual(header1337.1, 3)
        XCTAssertEqual(header8383.1, 3)
        XCTAssertEqual(header8384.1, 6)
        XCTAssertEqual(header111111111.1, 6)
        XCTAssertEqual(header4294967295.1, 6)
        XCTAssertEqual(headerOneExtra.1, 6) // Note 6, not 7
        
        // Validate body lengths
        XCTAssertEqual(header0.0.bodyLength()!, UInt32(0))
        XCTAssertEqual(header191.0.bodyLength()!, UInt32(191))
        XCTAssertEqual(header192.0.bodyLength()!, UInt32(192))
        XCTAssertEqual(header1337.0.bodyLength()!, UInt32(1337))
        XCTAssertEqual(header8383.0.bodyLength()!, UInt32(8383))
        XCTAssertEqual(header8384.0.bodyLength()!, UInt32(8384))
        XCTAssertEqual(header111111111.0.bodyLength()!, UInt32(111111111))
        XCTAssertEqual(header4294967295.0.bodyLength()!, UInt32(4294967295))
        XCTAssertEqual(headerOneExtra.0.bodyLength()!, UInt32(4294967295))
        
        // Validate that none of these deserialized as partial packets
        XCTAssertEqual(header0.0.isPartial(), false)
        XCTAssertEqual(header191.0.isPartial(), false)
        XCTAssertEqual(header192.0.isPartial(), false)
        XCTAssertEqual(header1337.0.isPartial(), false)
        XCTAssertEqual(header8383.0.isPartial(), false)
        XCTAssertEqual(header8384.0.isPartial(), false)
        XCTAssertEqual(header111111111.0.isPartial(), false)
        XCTAssertEqual(header4294967295.0.isPartial(), false)
        XCTAssertEqual(headerOneExtra.0.isPartial(), false)
        
        // Validate Packet Tags
        XCTAssertEqual(header0.0.packetType(), .PublicKeyEncryptedSessionKey)
        XCTAssertEqual(header191.0.packetType(), .ModificationDetectionCode)
        XCTAssertEqual(header192.0.packetType(), .Marker)
        XCTAssertEqual(header1337.0.packetType(), .Marker)
        XCTAssertEqual(header8383.0.packetType(), .Marker)
        XCTAssertEqual(header8384.0.packetType(), .Marker)
        XCTAssertEqual(header111111111.0.packetType(), .Marker)
        XCTAssertEqual(header4294967295.0.packetType(), .Marker)
        XCTAssertEqual(headerOneExtra.0.packetType(), .Marker)
    }
    
    private func deserializeFullFailureCases() {
        
        // Not enough bytes
        if NewPacketHeader.deserialize([0xC1]) != nil {
            XCTFail()
            return
        }
        
        // Enough bytes, first bit not set
        if NewPacketHeader.deserialize([0x41, 0x01]) != nil {
            XCTFail()
            return
        }
        
        // Enough bytes, second bit ("New Format") not set
        if NewPacketHeader.deserialize([0x81, 0x01]) != nil {
            XCTFail()
            return
        }
        
        // Not enough bytes for > one-octet length
        for i: UInt8 in 192..<224 {
            if NewPacketHeader.deserialize([0xC1, i]) != nil {
                XCTFail()
                return
            }
        }
        
        // Not enough bytes for a five-octet length
        if NewPacketHeader.deserialize([0xC1, 255]) != nil ||
            NewPacketHeader.deserialize([0xC1, 255, 255]) != nil ||
            NewPacketHeader.deserialize([0xC1, 255, 255, 255]) != nil ||
            NewPacketHeader.deserialize([0xC1, 255, 255, 255, 255]) != nil {
            XCTFail()
            return
        }
        
    }
    
    static var allTests : [(String, (NewPacketHeaderTests) -> () throws -> Void)] {
        return [
            ("testPacketHeaderMethods", testPacketHeaderMethods),
            ("testHighestTag", testHighestTag),
            ("testPartialWithMinimumLength", testPartialWithMinimumLength),
            ("testPartialWithMaximumLength", testPartialWithMaximumLength),
            ("testPartialWithOneLessThanMinimumLength", testPartialWithOneLessThanMinimumLength),
            ("testPartialWithOneMoreThanMaximumLength", testPartialWithOneMoreThanMaximumLength),
            ("testSerializePartial", testSerializePartial),
            ("testSerializeFull", testSerializeFull),
            ("testDeserializePartial", testDeserializePartial),
            ("testDeserializeFull", testDeserializeFull),
        ]
    }
}
