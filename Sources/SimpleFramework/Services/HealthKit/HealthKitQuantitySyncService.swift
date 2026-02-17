//
//  HealthKitQuantitySyncService.swift
//  SimpleFramework
//
//  Services/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import HealthKit

/// Typed adapter over `HealthKitQuantityServiceProtocol` for one quantity domain.
public struct HealthKitQuantitySyncService: HealthKitQuantitySyncServiceProtocol {
    private let descriptor: HealthKitQuantitySyncDescriptor
    private let quantityService: HealthKitQuantityServiceProtocol

    /// Stable provider identifier used for metadata records.
    public var providerIdentifier: String {
        descriptor.providerIdentifier
    }

    /// Creates a typed quantity sync service with a fixed descriptor.
    public init(
        descriptor: HealthKitQuantitySyncDescriptor,
        quantityService: HealthKitQuantityServiceProtocol
    ) {
        self.descriptor = descriptor
        self.quantityService = quantityService
    }

    /// Returns whether HealthKit data is available on the current device.
    public func isAvailable() async -> Bool {
        await quantityService.isAvailable()
    }

    /// Provides a stream of auto-sync state updates for this domain.
    public func observeAutoSyncEnabled() async -> AsyncStream<Bool> {
        await quantityService.observeAutoSyncEnabled(autoSyncKey: descriptor.autoSyncKey)
    }

    /// Returns the currently stored auto-sync flag for this domain.
    public func fetchAutoSyncEnabled() async -> Bool {
        await quantityService.fetchAutoSyncEnabled(autoSyncKey: descriptor.autoSyncKey)
    }

    /// Persists a new auto-sync flag and emits updates to observers.
    public func updateAutoSyncEnabled(_ isEnabled: Bool) async {
        await quantityService.updateAutoSyncEnabled(isEnabled, autoSyncKey: descriptor.autoSyncKey)
    }

    /// Clears the stored auto-sync flag and emits the default state.
    public func resetAutoSyncEnabled() async {
        await quantityService.resetAutoSyncEnabled(autoSyncKey: descriptor.autoSyncKey)
    }

    /// Returns the current read and write authorization state for this quantity domain.
    public func fetchPermissionState() async -> HealthKitPermissionState {
        await quantityService.fetchPermissionState(for: descriptor.quantityIdentifier)
    }

    /// Requests read/write authorization for this quantity domain and returns the resulting state.
    public func requestPermissions() async -> HealthKitPermissionState {
        await quantityService.requestPermissions(for: descriptor.quantityIdentifier)
    }

    /// Writes a sample only when auto-sync is enabled and write access is authorized.
    public func syncSampleIfEnabled(
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String? {
        try await quantityService.syncSampleIfEnabled(
            quantityIdentifier: descriptor.quantityIdentifier,
            autoSyncKey: descriptor.autoSyncKey,
            value: value,
            unit: unit,
            start: start,
            end: end
        )
    }

    /// Writes a sample regardless of auto-sync preference after validating availability and write authorization.
    public func syncSample(
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String {
        try await quantityService.syncSample(
            quantityIdentifier: descriptor.quantityIdentifier,
            value: value,
            unit: unit,
            start: start,
            end: end
        )
    }
}
