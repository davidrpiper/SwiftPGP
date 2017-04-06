//
//  Packet.swift
//  SwiftPGP
//
//  Created by David Piper on 30/3/17.
//

/**
    A protocol to be implemented by Packet Body classes.
 */
public protocol PacketBody: Serializable { }

/**
    RFC 4880, Section 4.
 */
public protocol Packet: Serializable {
    var header: PacketHeader { get }
    var body: PacketBody { get }
}

extension Packet {
    public func serialize() -> [UInt8] {
        return header.serialize() + body.serialize()
    }
    
    // Auto-delegate to subclasses
    public static func deserialize(_ bytes: [UInt8]) -> (Packet, Int)? {
        
        // Not enough bytes
        if bytes.count < 1 {
            return nil
        }
        
        // First bit not set
        if bytes[0] & 0x80 == 0 {
            return nil
        }
        
        let tag: PacketTag
        if bytes[0] & 0x40 == 0 {
            // Old packet header
            if let tagOpt = PacketTag(rawValue: (bytes[0] & 0x3C) >> 2) {
                tag = tagOpt
            } else {
                return nil
            }
        }
        else {
            // New packet header
            if let tagOpt = PacketTag(rawValue: (bytes[0] & 0x3F)) {
                tag = tagOpt
            } else {
                return nil
            }
        }
        
        switch tag {
        case .PublicKeyEncryptedSessionKey:
            if let packet = PublicKeyEncryptedSessionKeyPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .Signature:
            if let packet = SignaturePacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .SymmetricKeyEncryptedSessionKey:
            if let packet = SymmetricKeyEncryptedSessionKeyPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .OnePassSignature:
            if let packet = OnePassSignaturePacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .SecretKey:
            if let packet = SecretKeyPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .PublicKey:
            if let packet = PublicKeyPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .SecretSubkey:
            if let packet = SecretSubkeyPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .CompressedData:
            if let packet = CompressedDataPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .SymmetricallyEncryptedData:
            if let packet = SymmetricallyEncryptedDataPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .Marker:
            if let packet = MarkerPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .LiteralData:
            if let packet = LiteralDataPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .Trust:
            if let packet = TrustPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .UserId:
            if let packet = UserIdPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .PublicSubkey:
            if let packet = PublicSubkeyPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .UserAttribute:
            if let packet = UserAttributePacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .SymmetricallyEncryptedIntegrityProtectedData:
            if let packet = SymmetricallyEncryptedIntegrityProtectedDataPacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        case .ModificationDetectionCode:
            if let packet = ModificationDetectionCodePacket.deserialize(bytes) {
                return (packet.0, packet.1)
            }
        }
        
        return nil
    }
}
