//
//  ASCIIArmorHeader.swift
//  SwiftPGP
//
//  Created by David Piper on 1/4/17.
//

/**
    RFC 4880, Section 6.2.
 */
public enum ASCIIArmorHeader {
    case Version(String)
    case Comment(String)
    case MessageID(String)
    case Hash([HashAlgorithm])
    case Charset(String)
    
    public func headerString() -> String {
        switch self {
        case let .Version(ver):
            return "Version: \(ver)"
        case let .Comment(comment):
            return "Comment: \(comment)"
        case let .MessageID(id):
            return "MessageID: \(id)"
        case let .Hash(hashAlgorithms):
            let hashStrings = hashAlgorithms.map { $0.description }
            let csv = hashStrings.joined(separator: ",")
            return "Hash: \(csv)"
        case let .Charset(charset):
            return "Charset: \(charset)"
        }
    }
}
