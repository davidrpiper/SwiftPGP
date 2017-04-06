//
//  NewPacketHeader.swift
//  SwiftPGP
//
//  Created by David Piper on 30/3/17.
//

/**
    RFC 4880, Section 4.2.
 */
public struct NewPacketHeader: PacketHeader {
    private let tag: PacketTag
    private let _length: UInt32
    private let _isPartial: Bool
    
    /**
        Constructs a Packet Header in the 'new' format. If this is a partial
        packet, the length provided must be in the range [224, 255) as the
        actual packet length will be calculated as per RFC 4880, Section 4.2.2.4:
        
        partialPacket.bodyLength() := 1 << (`length` & 0x1f)
     */
    init?(tag: PacketTag, length: UInt32, isPartial: Bool) {
        if isPartial && (length < 224 || length >= 255) {
            return nil
        }
        self.tag = tag
        self._length = length
        self._isPartial = isPartial
    }
    
    /// MARK - PacketHeader
    
    public func format() -> PacketHeaderFormat {
        return .New
    }
    
    public func packetTag() -> PacketTag {
        return tag
    }
    
    public func isPartial() -> Bool {
        return _isPartial
    }
    
    public func bodyLength() -> UInt32? {
        if _isPartial {
            return 1 << (_length & 0x1F)
        }
        return _length
    }
    
    /// MARK - Serializable
    
    public func serialize() -> [UInt8] {
        let lengthOctets: [UInt8]
        
        if _isPartial {
            lengthOctets = [UInt8(_length)]
        }
        else {
            var varLength = bodyLength()!
            
            if (varLength <= 191) {
                lengthOctets = [UInt8(varLength)]
            }
            else if (varLength >= 192 && varLength <= 8383) {
                
                // bodyLen = ((1st_octet - 192) << 8) + (2nd_octet) + 192
                varLength -= 192
                var octet1: UInt8 = 192
                
                while varLength >= 256 {
                    octet1 += 1
                    varLength -= 256
                }
                let octet2: UInt8 = UInt8(varLength)
                
                lengthOctets = [octet1, octet2]
            }
            else {
                let lengthBytes: [UInt8] = GlobalOptions.isLittleEndian ?
                    withUnsafeBytes(of: &varLength) { Array($0) }.reversed() :
                    withUnsafeBytes(of: &varLength) { Array($0) }
                lengthOctets = [0xFF] + lengthBytes
            }
        }
        
        return [0x80 + 0x40 + tag.rawValue] + lengthOctets
    }
    
    public static func deserialize(_ bytes: [UInt8]) -> (NewPacketHeader, Int)? {
        if bytes.count < 2 {
            return nil
        }
        
        // If the first or second bit is not set, this is not a (new) PacketHeader
        if bytes[0] | UInt8(0xC0) != bytes[0] {
            return nil
        }
        
        guard let tag = PacketTag(rawValue: bytes[0] & UInt8(0x3F)) else {
            return nil
        }
        
        let length: UInt32
        let lengthOctetCount: Int
        let partial: Bool
        if bytes[1] < 192 {
            length = UInt32(bytes[1])
            partial = false
            lengthOctetCount = 1
        }
        else if bytes[1] < 224 && bytes.count >= 3 {
            length = ((UInt32(bytes[1]) - 192) << 8) + UInt32(bytes[2]) + 192
            partial = false
            lengthOctetCount = 2
        }
        else if bytes[1] < 255 {
            length = UInt32(bytes[1])
            partial = true
            lengthOctetCount = 1
        }
        else if bytes[1] == 255 && bytes.count >= 6 {
            let b2: UInt32 = UInt32(bytes[2]) << 24
            let b3: UInt32 = UInt32(bytes[3]) << 16
            let b4: UInt32 = UInt32(bytes[4]) << 8
            let b5: UInt32 = UInt32(bytes[5])
            length = b2 + b3 + b4 + b5
            partial = false
            lengthOctetCount = 5
        }
        else {
            return nil
        }
        
        guard let packetHeader = NewPacketHeader(tag: tag, length: length, isPartial: partial) else {
            return nil
        }
        
        return (packetHeader, 1 + lengthOctetCount)
    }
}
