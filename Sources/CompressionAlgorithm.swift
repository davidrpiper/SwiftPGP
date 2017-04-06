//
//  CompressionAlgorithm.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

/**
    RFC 4880, Section 9.3
 */
public enum CompressionAlgorithm: UInt8 {
    case Uncompressed = 0
    case ZIP = 1   // RFC1951
    case ZLIB = 2  // RFC1950
    case BZip2 = 3
}
