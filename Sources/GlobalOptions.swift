//
//  GlobalOptions.swift
//  SwiftPGP
//
//  Created by David Piper on 2/4/17.
//

public struct GlobalOptions {
    public static var isLittleEndian: Bool {
        return Int(littleEndian: 42) == 42
    }
    public static var serializeHeaderFormat: PacketHeaderFormat = .New
}
