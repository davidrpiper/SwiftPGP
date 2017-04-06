//
//  HashAlgorithm.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

/**
    RFC 4880, Section 9.4
 */
public enum HashAlgorithm: UInt8, CustomStringConvertible {
    case MD5 = 1
    case SHA1 = 2
    case RIPEMD160 = 3
    case SHA256 = 8
    case SHA384 = 9
    case SHA512 = 10
    case SHA224 = 11
    
    public var description: String {
        switch self {
        case .MD5: return "MD5"
        case .SHA1: return "SHA1"
        case .RIPEMD160: return "RIPEMD160"
        case .SHA256: return "SHA256"
        case .SHA384: return "SHA384"
        case .SHA512: return "SHA512"
        case .SHA224: return "SHA224"
        }
    }
}
