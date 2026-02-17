//
//  HealthKitEntrySyncMetadataService.swift
//  SimpleFramework
//
//  Services/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Service wrapper around a metadata store for HealthKit sync records.
public struct HealthKitEntrySyncMetadataService: HealthKitEntrySyncMetadataServiceProtocol {
    private let store: HealthKitEntrySyncMetadataStoreProtocol

    /// Creates a metadata service with the provided store dependency.
    public init(store: HealthKitEntrySyncMetadataStoreProtocol) {
        self.store = store
    }

    /// Provides a stream of metadata snapshots.
    public func observeMetadata() async throws -> AsyncStream<[HealthKitEntrySyncMetadata]> {
        try await store.observeMetadata()
    }

    /// Returns the latest metadata snapshot.
    public func fetchMetadata() async throws -> [HealthKitEntrySyncMetadata] {
        try await store.fetchMetadata()
    }

    /// Finds metadata for a local entry and provider identity pair.
    public func fetchMetadata(for entryID: UUID, providerIdentifier: String) async throws -> HealthKitEntrySyncMetadata? {
        let metadata = try await store.fetchMetadata()
        return metadata.first {
            $0.entryID == entryID && $0.providerIdentifier == providerIdentifier
        }
    }

    /// Inserts or updates one metadata record.
    public func upsertMetadata(_ metadata: HealthKitEntrySyncMetadata) async throws {
        try await store.upsertMetadata(metadata)
    }

    /// Deletes all metadata records for a local entry identifier.
    public func deleteMetadata(for entryID: UUID) async throws {
        try await store.deleteMetadata(for: entryID)
    }

    /// Deletes every metadata record.
    public func deleteAllMetadata() async throws {
        try await store.deleteAllMetadata()
    }
}
