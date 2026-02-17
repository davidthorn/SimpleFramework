//
//  StoreFilePathResolver.swift
//  SimpleFramework
//
//  Stores
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Default resolver for JSON store file URLs in the app documents directory.
public actor StoreFilePathResolver: StoreFilePathResolving {
    /// Creates a documents-directory file path resolver.
    public init() {}

    /// Resolves an absolute file URL for a given file name.
    public func fileURL(fileName: String) async throws -> URL {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw StoreInfrastructureError.documentsDirectoryUnavailable
        }
        return documentsURL.appendingPathComponent(fileName)
    }
}
