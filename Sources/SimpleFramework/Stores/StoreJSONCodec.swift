//
//  StoreJSONCodec.swift
//  SimpleFramework
//
//  Stores
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Shared JSON encoder/decoder configuration for generic stores.
public struct StoreJSONCodec {
    /// Encoder configured for stable JSON output and ISO-8601 dates.
    public let encoder: JSONEncoder
    /// Decoder configured for ISO-8601 dates.
    public let decoder: JSONDecoder

    /// Creates default JSON coding configuration for store persistence.
    public init() {
        let configuredEncoder = JSONEncoder()
        configuredEncoder.dateEncodingStrategy = .iso8601
        configuredEncoder.outputFormatting = [.sortedKeys]

        let configuredDecoder = JSONDecoder()
        configuredDecoder.dateDecodingStrategy = .iso8601

        encoder = configuredEncoder
        decoder = configuredDecoder
    }
}
