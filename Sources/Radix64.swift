//
//  Radix64.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

import Foundation

/**
    RFC 4880, Sections 6.3 - 6.6.
 */
public struct Radix64 {
    
    /// Radix-64 (base-64) encode a stream of bytes. Does not calculate and return the CRC checksum.
    static func encode(bytes: [UInt8]) -> String {
        let data = Data(bytes)
        return data.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength76Characters)
    }
    
    /// Returns the base64 encoded CRC for bytes (including the '=' prefix)
    static func checksum(bytes: [UInt8]) -> String {
        var crc = CRC24.generate(fromBytes: bytes)
        
        let crcBytes: [UInt8] = GlobalOptions.isLittleEndian ?
            withUnsafeBytes(of: &crc) { Array($0) }.reversed() :
            withUnsafeBytes(of: &crc) { Array($0) }.reversed()

        return "=" + Radix64.encode(bytes: crcBytes)
    }
    
    /// Decode a Radix-64 string into its original data. Ignores invalid characters (e.g. newlines).
    /// Returns nil if the string cannot be decoded successfully.
    static func decode(string: String) -> [UInt8]? {
        if let data = Data(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            return [UInt8](data)
        }
        return nil
    }
}
