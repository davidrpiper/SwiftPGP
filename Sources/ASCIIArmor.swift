//
//  ASCIIArmor.swift
//  SwiftPGP
//
//  Created by David Piper on 1/4/17.
//

/**
    RFC 4880, Section 6.2.
 */
public struct ASCIIArmor: Serializable {
    let type: ASCIIArmorBlockType
    let headers: [ASCIIArmorHeader]
    let data: String
    let crc: String
    
    ///
    /// MARK - Serializable
    ///
    
    public static func deserialize(_ bytes: [UInt8]) -> (ASCIIArmor, Int)? {
        // TODO
        return nil
    }
    
    // Convenience overload
    public static func deserialize(_ bytes: String) -> (ASCIIArmor, Int)? {
        // TODO
        return nil
    }
    
    public func serialize() -> [UInt8] {
        let pair = type.linePair()
        let heads = headers.reduce("") {
            $0 + $1.headerString() + "\n"
        }
        
        let fullString =
            pair.header + "\n" +
            heads + "\n" +
            data + "\n" +
            crc + "\n" +
            pair.tail + "\n"
        
        return Array(fullString.utf8)
    }
    
}
