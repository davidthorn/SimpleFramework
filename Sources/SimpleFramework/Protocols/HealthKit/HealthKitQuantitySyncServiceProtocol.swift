//
//  HealthKitQuantitySyncServiceProtocol.swift
//  SimpleFramework
//
//  Protocols/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import HealthKit

/// Defines a typed HealthKit quantity sync service backed by a fixed domain descriptor.
public protocol HealthKitQuantitySyncServiceProtocol: Sendable {
    /// Stable provider identifier used for metadata records.
    var providerIdentifier: String { get }
    /// Returns whether HealthKit data is available on the current device.
    func isAvailable() async -> Bool
    /// Provides a stream of auto-sync state updates for this domain.
    func observeAutoSyncEnabled() async -> AsyncStream<Bool>
    /// Returns the currently stored auto-sync flag for this domain.
    func fetchAutoSyncEnabled() async -> Bool
    /// Persists a new auto-sync flag and emits updates to observers.
    func updateAutoSyncEnabled(_ isEnabled: Bool) async
    /// Clears the stored auto-sync flag and emits the default state.
    func resetAutoSyncEnabled() async

    /// Returns the current read and write authorization state for this quantity domain.
    func fetchPermissionState() async -> HealthKitPermissionState
    /// Requests read/write authorization for this quantity domain and returns the resulting state.
    func requestPermissions() async -> HealthKitPermissionState

    /// Writes a sample only when auto-sync is enabled and write access is authorized.
    ///
    /// - Returns: The saved HealthKit sample UUID string, or `nil` when sync is skipped.
    func syncSampleIfEnabled(
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String?

    /// Writes a sample regardless of auto-sync preference after validating availability and write authorization.
    ///
    /// - Returns: The saved HealthKit sample UUID string.
    func syncSample(
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String
}
