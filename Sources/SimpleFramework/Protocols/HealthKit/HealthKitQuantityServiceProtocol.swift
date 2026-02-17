//
//  HealthKitQuantityServiceProtocol.swift
//  SimpleFramework
//
//  Protocols/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import HealthKit

/// Defines a reusable HealthKit quantity service for availability, permissions, and sample writes.
public protocol HealthKitQuantityServiceProtocol: Sendable {
    /// Returns whether HealthKit data is available on the current device.
    func isAvailable() async -> Bool
    /// Provides a stream of auto-sync state updates for a specific preference key.
    func observeAutoSyncEnabled(autoSyncKey: String) async -> AsyncStream<Bool>
    /// Returns the currently stored auto-sync flag for a specific preference key.
    func fetchAutoSyncEnabled(autoSyncKey: String) async -> Bool
    /// Persists a new auto-sync flag and emits updates to observers.
    func updateAutoSyncEnabled(_ isEnabled: Bool, autoSyncKey: String) async
    /// Clears the stored auto-sync flag and emits the default state.
    func resetAutoSyncEnabled(autoSyncKey: String) async

    /// Returns the current read and write authorization state for the provided quantity type.
    func fetchPermissionState(for quantityIdentifier: HKQuantityTypeIdentifier) async -> HealthKitPermissionState
    /// Requests read/write authorization for the provided quantity type and returns the resulting state.
    func requestPermissions(for quantityIdentifier: HKQuantityTypeIdentifier) async -> HealthKitPermissionState

    /// Writes a sample only when auto-sync is enabled and write access is authorized for the provided quantity type.
    ///
    /// - Returns: The saved HealthKit sample UUID string, or `nil` when sync is skipped.
    func syncSampleIfEnabled(
        quantityIdentifier: HKQuantityTypeIdentifier,
        autoSyncKey: String,
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String?

    /// Writes a sample regardless of auto-sync preference after validating availability and write authorization for the provided quantity type.
    ///
    /// - Returns: The saved HealthKit sample UUID string.
    func syncSample(
        quantityIdentifier: HKQuantityTypeIdentifier,
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String
}
