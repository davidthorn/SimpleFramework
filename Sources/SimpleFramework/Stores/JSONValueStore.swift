//
//  JSONValueStore.swift
//  SimpleFramework
//
//  Stores
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Generic actor-backed JSON store for one optional `Codable` value.
public actor JSONValueStore<Value: Codable & Sendable>: JSONValueStoreProtocol {
    private let fileName: String
    private let fileManager: FileManager
    private let filePathResolver: StoreFilePathResolving
    private let codec: StoreJSONCodec

    private var cachedValue: Value?
    private var hasLoaded: Bool
    private var streamContinuations: [UUID: AsyncStream<Value?>.Continuation]

    /// Creates a generic JSON value store in the app documents directory.
    public init(
        fileName: String,
        fileManager: FileManager = .default,
        filePathResolver: StoreFilePathResolving? = nil,
        codec: StoreJSONCodec = StoreJSONCodec()
    ) {
        self.fileName = fileName
        self.fileManager = fileManager
        self.filePathResolver = filePathResolver ?? StoreFilePathResolver()
        self.codec = codec

        cachedValue = nil
        hasLoaded = false
        streamContinuations = [:]
    }

    /// Provides a stream of value snapshots.
    public func observeValue() async throws -> AsyncStream<Value?> {
        try await ensureLoaded()

        let streamID = UUID()
        let initialSnapshot = cachedValue
        let streamPair = AsyncStream<Value?>.makeStream()

        streamPair.continuation.onTermination = { [weak self] _ in
            Task {
                await self?.removeStreamContinuation(streamID: streamID)
            }
        }

        streamContinuations[streamID] = streamPair.continuation
        streamPair.continuation.yield(initialSnapshot)
        return streamPair.stream
    }

    /// Returns the latest value snapshot.
    public func fetchValue() async throws -> Value? {
        try await ensureLoaded()
        return cachedValue
    }

    /// Inserts or updates the stored value.
    public func upsertValue(_ value: Value) async throws {
        try await ensureLoaded()
        cachedValue = value
        try await persistValue()
        publishValueSnapshot()
    }

    /// Deletes the stored value.
    public func deleteValue() async throws {
        try await ensureLoaded()

        guard cachedValue != nil else {
            return
        }

        cachedValue = nil
        try await persistValue()
        publishValueSnapshot()
    }

    private func ensureLoaded() async throws {
        guard hasLoaded == false else {
            return
        }

        cachedValue = try await loadPersistedValue()
        hasLoaded = true
    }

    private func loadPersistedValue() async throws -> Value? {
        let fileURL = try await filePathResolver.fileURL(fileName: fileName)

        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }

        let data = try Data(contentsOf: fileURL)
        guard data.isEmpty == false else {
            return nil
        }

        return try codec.decoder.decode(Value.self, from: data)
    }

    private func persistValue() async throws {
        let fileURL = try await filePathResolver.fileURL(fileName: fileName)

        if let value = cachedValue {
            let encodedData = try codec.encoder.encode(value)
            try encodedData.write(to: fileURL, options: .atomic)
            return
        }

        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }

    private func publishValueSnapshot() {
        let snapshot = cachedValue
        for continuation in streamContinuations.values {
            continuation.yield(snapshot)
        }
    }

    private func removeStreamContinuation(streamID: UUID) {
        streamContinuations.removeValue(forKey: streamID)
    }
}
