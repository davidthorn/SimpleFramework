//
//  HealthKitEntrySyncMetadata.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// External synchronization record for a local entry synced to HealthKit.
public struct HealthKitEntrySyncMetadata: Codable, Identifiable, Hashable, Sendable {
    /// Stable metadata identifier.
    public let id: UUID
    /// Local source entry identifier.
    public let entryID: UUID
    /// Provider identity (for example `healthkit.bodyMass`).
    public let providerIdentifier: String
    /// External provider record identifier (for example HealthKit sample UUID).
    public let externalIdentifier: String
    /// Timestamp when sync completed.
    public let syncedAt: Date

    /// Creates a sync metadata record.
    public init(
        id: UUID = UUID(),
        entryID: UUID,
        providerIdentifier: String,
        externalIdentifier: String,
        syncedAt: Date
    ) {
        self.id = id
        self.entryID = entryID
        self.providerIdentifier = providerIdentifier
        self.externalIdentifier = externalIdentifier
        self.syncedAt = syncedAt
    }
}
