//
//  JSONValueStoreProtocol.swift
//  SimpleFramework
//
//  Protocols
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines persistence and streaming operations for an actor-backed JSON optional value store.
public protocol JSONValueStoreProtocol: Sendable {
    /// Value type persisted by the store.
    associatedtype Value: Codable & Sendable

    /// Provides a stream of value snapshots.
    func observeValue() async throws -> AsyncStream<Value?>
    /// Returns the latest value snapshot.
    func fetchValue() async throws -> Value?
    /// Inserts or updates the stored value.
    func upsertValue(_ value: Value) async throws
    /// Deletes the stored value.
    func deleteValue() async throws
}
