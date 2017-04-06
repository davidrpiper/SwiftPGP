//
//  CRC24.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

/**
    RFC 4880, Section 6.1.
 */
public struct CRC24 {
    private static let INIT: UInt32 = 0xB704CE
    private static let POLY: UInt32 = 0x1864CFB
    
    static func generate(fromBytes bytes: [UInt8]) -> UInt32 {
        var crc: UInt32 = CRC24.INIT
        
        for octet in bytes {
            crc = crc ^ (UInt32(octet) << 16)
            for _ in 0..<8 {
                crc = crc << 1
                if (crc & 0x1000000) != 0 {
                    crc = crc ^ CRC24.POLY
                }
            }
        }
        
        return crc & 0xFFFFFF
    }
}
