//
//  HealthKitAutoSyncPreferenceStoreProtocol.swift
//  SimpleFramework
//
//  Protocols/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines read/write and streaming access for a HealthKit auto-sync preference flag.
public protocol HealthKitAutoSyncPreferenceStoreProtocol: Sendable {
    /// Provides a stream of auto-sync state updates.
    func observeAutoSyncEnabled() async -> AsyncStream<Bool>
    /// Returns the currently stored auto-sync flag.
    func fetchAutoSyncEnabled() async -> Bool
    /// Persists a new auto-sync flag and emits updates to observers.
    func updateAutoSyncEnabled(_ isEnabled: Bool) async
    /// Clears the stored auto-sync flag and emits the default state.
    func resetAutoSyncEnabled() async
}
