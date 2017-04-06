//
//  MarkerPacket.swift
//  SwiftPGP
//
//  Created by David Piper on 2/4/17.
//

import Foundation

/**
    RFC 4880, Section 5.8.
 */
public struct MarkerPacket: Packet {
    
    public static func deserialize(_ bytes: [UInt8]) -> (MarkerPacket, Int)? {
        
        guard let header = NewPacketHeader.deserialize(bytes) else {
            return nil
        }
        
        if bytes.count < 5 {
            return nil
        }
        
        if bytes[1] == 3 {
            if bytes[2] == 0x50 && bytes[3] == 0x47 && bytes[4] == 0x50 {
                if bytes[0] == 0xC0 + PacketTag.Marker.rawValue {
                    // New Packet header
                    return (MarkerPacket(), 5)
                }
                else if bytes[0] == 0x80 + (PacketTag.Marker.rawValue << 2) {
                    // Old Packet header
                    return (MarkerPacket(), 5)
                }
            }
        }
        
        return nil
    }
    
    public func header(format: PacketHeaderFormat) -> PacketHeader {
        if format == .New {
            return NewPacketHeader(tag: .Marker, length: 3, isPartial: false)!
        }
        return OldPacketHeader(tag: .Marker, length: 3)!
    }
    
    public func body() -> PacketBody {
        return MarkerPacketBody()
    }
}

public struct MarkerPacketBody: PacketBody {
    public func serialize() -> [UInt8] {
        return [0x50, 0x47, 0x50] // "PGP"
    }
    
    public static func deserialize(_ bytes: [UInt8]) -> (MarkerPacketBody, Int)? {
        if bytes.count < 3 {
            return nil
        }
        if bytes[0] != 0x50 || bytes[1] != 0x47 || bytes[2] != 0x50 {
            return nil
        }
        return (MarkerPacketBody(), 3)
    }
}
