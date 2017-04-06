//
//  SymmetricKeyAlgorithm.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

/**
    RFC 4880, Section 9.2
 */
public enum SymmetricKeyAlgorithm: UInt8 {
    case Unencrypted = 0
    case IDEA = 1
    case TripleDES = 2  // 168 bit key derived from 192
    case CASTS = 3      // 128 bit key, as per RFC2144
    case Blowfish = 4   // 128 bit key, 16 rounds
    case AES128 = 7
    case AES192 = 8
    case AES256 = 9
    case Twofish = 10   // 256-bit key
}
