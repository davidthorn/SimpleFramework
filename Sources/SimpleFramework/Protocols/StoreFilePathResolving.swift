//
//  StoreFilePathResolving.swift
//  SimpleFramework
//
//  Protocols
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines file path resolution for JSON-backed stores.
public protocol StoreFilePathResolving: Sendable {
    /// Resolves an absolute file URL for a given file name.
    func fileURL(fileName: String) async throws -> URL
}
