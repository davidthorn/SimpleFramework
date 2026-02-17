//
//  JSONEntityStoreProtocol.swift
//  SimpleFramework
//
//  Protocols
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines persistence and streaming operations for an actor-backed JSON entity store.
public protocol JSONEntityStoreProtocol: Sendable {
    /// Entity type persisted by the store.
    associatedtype Entity: Codable & Identifiable & Sendable where Entity.ID: Hashable & Sendable

    /// Provides a stream of entity snapshots.
    func observeEntities() async throws -> AsyncStream<[Entity]>
    /// Returns the latest entity snapshot.
    func fetchEntities() async throws -> [Entity]
    /// Inserts or updates one entity by matching `id`.
    func upsertEntity(_ entity: Entity) async throws
    /// Deletes all entities matching a specific identifier.
    func deleteEntity(id: Entity.ID) async throws
    /// Deletes every entity.
    func deleteAllEntities() async throws
}
