//
//  HealthKitEntrySyncMetadataStore.swift
//  SimpleFramework
//
//  Stores/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Actor-backed JSON store for HealthKit sync metadata records.
public actor HealthKitEntrySyncMetadataStore: HealthKitEntrySyncMetadataStoreProtocol {
    private let fileName: String
    private let fileManager: FileManager
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private var cachedMetadata: [HealthKitEntrySyncMetadata]
    private var hasLoaded: Bool
    private var streamContinuations: [UUID: AsyncStream<[HealthKitEntrySyncMetadata]>.Continuation]

    /// Creates a metadata store using a JSON file in the app documents directory.
    public init(
        fileName: String = "healthkit_entry_sync_metadata.json",
        fileManager: FileManager = .default
    ) {
        self.fileName = fileName
        self.fileManager = fileManager

        let configuredEncoder = JSONEncoder()
        configuredEncoder.dateEncodingStrategy = .iso8601
        configuredEncoder.outputFormatting = [.sortedKeys]
        encoder = configuredEncoder

        let configuredDecoder = JSONDecoder()
        configuredDecoder.dateDecodingStrategy = .iso8601
        decoder = configuredDecoder

        cachedMetadata = []
        hasLoaded = false
        streamContinuations = [:]
    }

    /// Provides a stream of metadata snapshots.
    public func observeMetadata() async throws -> AsyncStream<[HealthKitEntrySyncMetadata]> {
        try await ensureLoaded()

        let streamID = UUID()
        let initialSnapshot = cachedMetadata
        let streamPair = AsyncStream<[HealthKitEntrySyncMetadata]>.makeStream()

        streamPair.continuation.onTermination = { [weak self] _ in
            Task {
                await self?.removeStreamContinuation(streamID: streamID)
            }
        }

        streamContinuations[streamID] = streamPair.continuation
        streamPair.continuation.yield(initialSnapshot)
        return streamPair.stream
    }

    /// Returns the latest metadata snapshot.
    public func fetchMetadata() async throws -> [HealthKitEntrySyncMetadata] {
        try await ensureLoaded()
        return cachedMetadata
    }

    /// Inserts or updates one metadata record.
    public func upsertMetadata(_ metadata: HealthKitEntrySyncMetadata) async throws {
        try await ensureLoaded()

        if let index = cachedMetadata.firstIndex(where: {
            $0.entryID == metadata.entryID && $0.providerIdentifier == metadata.providerIdentifier
        }) {
            cachedMetadata[index] = metadata
        } else {
            cachedMetadata.append(metadata)
        }

        sortCachedMetadata()
        try await persistMetadata()
        publishMetadataSnapshot()
    }

    /// Deletes all metadata records for a local entry identifier.
    public func deleteMetadata(for entryID: UUID) async throws {
        try await ensureLoaded()

        let previousCount = cachedMetadata.count
        cachedMetadata.removeAll { $0.entryID == entryID }

        guard previousCount != cachedMetadata.count else {
            return
        }

        try await persistMetadata()
        publishMetadataSnapshot()
    }

    /// Deletes every metadata record.
    public func deleteAllMetadata() async throws {
        try await ensureLoaded()
        guard cachedMetadata.isEmpty == false else {
            return
        }

        cachedMetadata.removeAll()
        try await persistMetadata()
        publishMetadataSnapshot()
    }

    private func ensureLoaded() async throws {
        guard hasLoaded == false else {
            return
        }

        cachedMetadata = try await loadPersistedMetadata()
        sortCachedMetadata()
        hasLoaded = true
    }

    private func loadPersistedMetadata() async throws -> [HealthKitEntrySyncMetadata] {
        let fileURL = try documentsFileURL(fileName: fileName)

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        guard data.isEmpty == false else {
            return []
        }

        return try decoder.decode([HealthKitEntrySyncMetadata].self, from: data)
    }

    private func persistMetadata() async throws {
        let fileURL = try documentsFileURL(fileName: fileName)
        let encodedData = try encoder.encode(cachedMetadata)
        try encodedData.write(to: fileURL, options: .atomic)
    }

    private func documentsFileURL(fileName: String) throws -> URL {
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw HealthKitSyncMetadataStoreError.documentsDirectoryUnavailable
        }
        return documentsURL.appendingPathComponent(fileName)
    }

    private func sortCachedMetadata() {
        cachedMetadata.sort { $0.syncedAt > $1.syncedAt }
    }

    private func publishMetadataSnapshot() {
        let snapshot = cachedMetadata
        for continuation in streamContinuations.values {
            continuation.yield(snapshot)
        }
    }

    private func removeStreamContinuation(streamID: UUID) {
        streamContinuations.removeValue(forKey: streamID)
    }
}
