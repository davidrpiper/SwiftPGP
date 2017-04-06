//
//  PacketHeader.swift
//  SwiftPGP
//
//  Created by David Piper on 30/3/17.
//

/**
    RFC 4880, Section 4.2.
 */
public protocol PacketHeader: Serializable {
    
    /**
        Returns the format of this packet
     */
    func format() -> PacketHeaderFormat
    
    /**
        Returns the Packet Tag in this header
     */
    func packetTag() -> PacketTag
    
    /**
        Returns the length of this packet's body (i.e. the number
        of octets in the body), partial or full.
     
        For old format packets, if the packet header indicates the
        body length is indeterminate, nil is returned.
     */
    func bodyLength() -> UInt32?
    
    /**
        Returns true if this is packet contains a Partial Body
        Length header (and is therefore a new format packet).
        Returns false otherwise.
     */
    func isPartial() -> Bool
    
    /**
        If this packet is an old format packet, return the length-type.
        Returns nil for new format packets.
     */
    func oldFormatLengthType() -> OldPacketFormatLength?
}

extension PacketHeader {
    
    /**
        Convenience alias for packetTag()
     */
    func packetType() -> PacketType {
        return packetTag()
    }
}
