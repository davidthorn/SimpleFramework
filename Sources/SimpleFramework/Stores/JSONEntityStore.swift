//
//  JSONEntityStore.swift
//  SimpleFramework
//
//  Stores
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Generic actor-backed JSON store for `Identifiable` entities.
public actor JSONEntityStore<Entity: Codable & Identifiable & Sendable>: JSONEntityStoreProtocol where Entity.ID: Hashable & Sendable {
    private let fileName: String
    private let fileManager: FileManager
    private let filePathResolver: StoreFilePathResolving
    private let codec: StoreJSONCodec
    private let sort: (@Sendable (Entity, Entity) -> Bool)?

    private var cachedEntities: [Entity]
    private var hasLoaded: Bool
    private var streamContinuations: [UUID: AsyncStream<[Entity]>.Continuation]

    /// Creates a generic JSON entity store in the app documents directory.
    public init(
        fileName: String,
        fileManager: FileManager = .default,
        filePathResolver: StoreFilePathResolving? = nil,
        codec: StoreJSONCodec = StoreJSONCodec(),
        sort: (@Sendable (Entity, Entity) -> Bool)? = nil
    ) {
        self.fileName = fileName
        self.fileManager = fileManager
        self.filePathResolver = filePathResolver ?? StoreFilePathResolver()
        self.codec = codec
        self.sort = sort

        cachedEntities = []
        hasLoaded = false
        streamContinuations = [:]
    }

    /// Provides a stream of entity snapshots.
    public func observeEntities() async throws -> AsyncStream<[Entity]> {
        try await ensureLoaded()

        let streamID = UUID()
        let initialSnapshot = cachedEntities
        let streamPair = AsyncStream<[Entity]>.makeStream()

        streamPair.continuation.onTermination = { [weak self] _ in
            Task {
                await self?.removeStreamContinuation(streamID: streamID)
            }
        }

        streamContinuations[streamID] = streamPair.continuation
        streamPair.continuation.yield(initialSnapshot)
        return streamPair.stream
    }

    /// Returns the latest entity snapshot.
    public func fetchEntities() async throws -> [Entity] {
        try await ensureLoaded()
        return cachedEntities
    }

    /// Inserts or updates one entity by matching `id`.
    public func upsertEntity(_ entity: Entity) async throws {
        try await ensureLoaded()

        if let index = cachedEntities.firstIndex(where: { $0.id == entity.id }) {
            cachedEntities[index] = entity
        } else {
            cachedEntities.append(entity)
        }

        sortCachedEntitiesIfNeeded()
        try await persistEntities()
        publishEntitySnapshot()
    }

    /// Deletes all entities matching a specific identifier.
    public func deleteEntity(id: Entity.ID) async throws {
        try await ensureLoaded()

        let previousCount = cachedEntities.count
        cachedEntities.removeAll { $0.id == id }

        guard previousCount != cachedEntities.count else {
            return
        }

        try await persistEntities()
        publishEntitySnapshot()
    }

    /// Deletes every entity.
    public func deleteAllEntities() async throws {
        try await ensureLoaded()
        guard cachedEntities.isEmpty == false else {
            return
        }

        cachedEntities.removeAll()
        try await persistEntities()
        publishEntitySnapshot()
    }

    private func ensureLoaded() async throws {
        guard hasLoaded == false else {
            return
        }

        cachedEntities = try await loadPersistedEntities()
        sortCachedEntitiesIfNeeded()
        hasLoaded = true
    }

    private func loadPersistedEntities() async throws -> [Entity] {
        let fileURL = try await filePathResolver.fileURL(fileName: fileName)

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        guard data.isEmpty == false else {
            return []
        }

        return try codec.decoder.decode([Entity].self, from: data)
    }

    private func persistEntities() async throws {
        let fileURL = try await filePathResolver.fileURL(fileName: fileName)
        let encodedData = try codec.encoder.encode(cachedEntities)
        try encodedData.write(to: fileURL, options: .atomic)
    }

    private func sortCachedEntitiesIfNeeded() {
        guard let sort else {
            return
        }
        cachedEntities.sort(by: sort)
    }

    private func publishEntitySnapshot() {
        let snapshot = cachedEntities
        for continuation in streamContinuations.values {
            continuation.yield(snapshot)
        }
    }

    private func removeStreamContinuation(streamID: UUID) {
        streamContinuations.removeValue(forKey: streamID)
    }
}
