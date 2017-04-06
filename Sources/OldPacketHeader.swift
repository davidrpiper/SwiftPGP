//
//  OldPacketHeader.swift
//  SwiftPGP
//
//  Created by David Piper on 30/3/17.
//

/**
    RFC 4880, Section 4.2.
 */
public struct OldPacketHeader: PacketHeader {
    let tag: PacketTag
    let _length: UInt32?
    
    /// Pass length = nil for a packet of indeterminate length
    public init?(tag: PacketTag, length: UInt32?) {
        if tag.rawValue > 15 {
            return nil
        }
        self.tag = tag
        self._length = length
    }
    
    public func format() -> PacketHeaderFormat {
        return .Old
    }
    
    public func packetTag() -> PacketTag {
        return tag
    }
    
    public func bodyLength() -> UInt32? {
        return _length
    }
    
    public func isPartial() -> Bool {
        return false
    }
    
    public func oldFormatLengthType() -> OldPacketFormatLength? {
        if let length = _length {
            if length <= 0xFF {
                return OldPacketFormatLength.OneOctet
            }
            if length < 0xFFFF {
                return OldPacketFormatLength.TwoOctets
            }
            return OldPacketFormatLength.FourOctets
        }
        
        return OldPacketFormatLength.Indeterminate
    }
    
    /// MARK - Serializable
    
    public static func deserialize(_ bytes: [UInt8]) -> (OldPacketHeader, Int)? {
        return nil
    }
    
    public func serialize() -> [UInt8] {
        if let length = _length {
            var varLength = length
            let lengthBytes = withUnsafePointer(to: &varLength) { lenPointer in
                lenPointer.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<UInt32>.size) { reboundPtr in
                    Array(UnsafeBufferPointer(start: reboundPtr, count: MemoryLayout<UInt32>.size))
                }
            }
            // TODO: Check if we need to reverse the array due to endianness...
            return [0x80 + (tag.rawValue << 2) + oldFormatLengthType()!.rawValue] + lengthBytes
        }
        
        return [0x80 + (tag.rawValue << 2) + oldFormatLengthType()!.rawValue]
    }
}
