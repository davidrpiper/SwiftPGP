//
//  ASCIIArmorBlockType.swift
//  SwiftPGP
//
//  Created by David Piper on 1/4/17.
//

/**
    RFC 4880, Section 6.2.
 */
public enum ASCIIArmorBlockType {
    case Message
    case PublicKeyBlock
    case PrivateKeyBlock
    case MessagePartXofY(UInt, UInt)
    case MessagePartX(UInt)
    case Signature
    
    public func linePair() -> (header: String, tail: String) {
        switch self {
        case .Message:
            return (header: "-----BEGIN PGP MESSAGE-----",
                    tail: "-----END PGP MESSAGE-----")
        case .PublicKeyBlock:
            return (header: "-----BEGIN PGP PUBLIC KEY BLOCK-----",
                    tail: "-----END PGP PUBLIC KEY BLOCK-----")
        case .PrivateKeyBlock:
            return (header: "-----BEGIN PGP PRIVATE KEY BLOCK-----",
                    tail: "-----END PGP PRIVATE KEY BLOCK-----")
        case let .MessagePartXofY(X, Y):
            return (header: "-----BEGIN PGP MESSAGE, PART \(X)/\(Y)-----",
                    tail: "-----END PGP MESSAGE, PART \(X)/\(Y)-----")
        case let .MessagePartX(X):
            return (header: "-----BEGIN PGP MESSAGE, PART \(X)-----",
                    tail: "-----END PGP MESSAGE, PART \(X)-----")
        case .Signature:
            return (header: "-----BEGIN PGP SIGNATURE-----",
                    tail: "-----END PGP SIGNATURE-----")
        }
    }
}
