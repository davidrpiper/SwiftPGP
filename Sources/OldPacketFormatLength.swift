//
//  OldPacketFormatLength.swift
//  SwiftPGP
//
//  Created by David Piper on 30/3/17.
//

/**
    RFC 4880, Section 4.2.1.
 */
public enum OldPacketFormatLength: UInt8 {
    case OneOctet = 0
    case TwoOctets = 1
    case FourOctets = 2
    case Indeterminate = 3
}
