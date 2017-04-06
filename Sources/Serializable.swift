//
//  Serializable.swift
//  SwiftPGP
//
//  Created by David Piper on 31/3/17.
//

/**
    A protocol for data structures that can be deserialized from
    raw data - including a method that serializes it back out again.
 */
public protocol Serializable {
    /**
        Returns an object deserialized from a Data stream. If
        deserialization is successful, this method returns the
        constructed object and an integer indicating how many bytes
        in the Data object comprised the constructed object. If
        deserialization is unsuccessful, nil is returned.
     */
    static func deserialize(_ bytes: [UInt8]) -> (Self, Int)?
    
    /**
        Serialize the object into a Data object. The object returned
        from deserialize(bytes:) should serialize() into an identical
        Data object.
     */
    func serialize() -> [UInt8]
}
