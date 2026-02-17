//
//  HealthKitEntrySyncMetadataServiceProtocol.swift
//  SimpleFramework
//
//  Protocols/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines orchestration operations for querying and mutating HealthKit entry sync metadata.
public protocol HealthKitEntrySyncMetadataServiceProtocol: Sendable {
    /// Provides a stream of metadata snapshots.
    func observeMetadata() async throws -> AsyncStream<[HealthKitEntrySyncMetadata]>
    /// Returns the latest metadata snapshot.
    func fetchMetadata() async throws -> [HealthKitEntrySyncMetadata]
    /// Finds metadata for a local entry and provider identity pair.
    func fetchMetadata(for entryID: UUID, providerIdentifier: String) async throws -> HealthKitEntrySyncMetadata?
    /// Inserts or updates one metadata record.
    func upsertMetadata(_ metadata: HealthKitEntrySyncMetadata) async throws
    /// Deletes all metadata records for a local entry identifier.
    func deleteMetadata(for entryID: UUID) async throws
    /// Deletes every metadata record.
    func deleteAllMetadata() async throws
}
