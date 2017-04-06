//
//  PacketTag.swift
//  SwiftPGP
//
//  Created by David Piper on 30/3/17.
//

/**
    RFC 4880, Section 4.3.
    PacketTags denote what type of Packet the body holds.
 */
public enum PacketTag: UInt8 {
    case PublicKeyEncryptedSessionKey = 1
    case Signature = 2
    case SymmetricKeyEncryptedSessionKey = 3
    case OnePassSignature = 4
    case SecretKey = 5
    case PublicKey = 6
    case SecretSubkey = 7
    case CompressedData = 8
    case SymmetricallyEncryptedData = 9
    case Marker = 10
    case LiteralData = 11
    case Trust = 12
    case UserId = 13
    case PublicSubkey = 14
    case UserAttribute = 17
    case SymmetricallyEncryptedIntegrityProtectedData = 18
    case ModificationDetectionCode = 19
}

/**
    Typealias for PacketTag. The terms can be used interchangeably.
 */
public typealias PacketType = PacketTag
