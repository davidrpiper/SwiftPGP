//
//  PublicKeyAlgorithm.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

/**
    RFC 4880, Section 9.1.
    Raw value is Algorithm ID
 */
public enum PublicKeyAlgorithm: UInt8 {
    case RSAEncryptOrSign = 1
    case RSAEncryptOnly = 2
    case RSASignOnly = 3
    case ElgamalEncryptOnly = 16
    case DSA = 17
    case EllipticCurve = 18         // (Reserved)
    case ECDSA = 19                 // (Reserved)
    case Reserved = 20              // (Reserved) Formerly Elgamal Encrypt or Sign
    case DiffieHellman = 21         // (Reserved) X9.42, as defined for IETF-S/MIME
}
