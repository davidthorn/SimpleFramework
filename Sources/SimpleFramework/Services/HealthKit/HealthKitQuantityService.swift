//
//  HealthKitQuantityService.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import HealthKit

public actor HealthKitQuantityService: HealthKitQuantityServiceProtocol {
    private let healthStore: HKHealthStore
    private var autoSyncStores: [String: HealthKitAutoSyncPreferenceStore]

    public init(healthStore: HKHealthStore = HKHealthStore()) {
        self.healthStore = healthStore
        autoSyncStores = [:]
    }

    public func isAvailable() async -> Bool {
        HKHealthStore.isHealthDataAvailable()
    }

    public func observeAutoSyncEnabled(autoSyncKey: String) async -> AsyncStream<Bool> {
        let store = autoSyncStore(for: autoSyncKey)
        return await store.observeAutoSyncEnabled()
    }

    public func fetchAutoSyncEnabled(autoSyncKey: String) async -> Bool {
        let store = autoSyncStore(for: autoSyncKey)
        return await store.fetchAutoSyncEnabled()
    }

    public func updateAutoSyncEnabled(_ isEnabled: Bool, autoSyncKey: String) async {
        let store = autoSyncStore(for: autoSyncKey)
        await store.updateAutoSyncEnabled(isEnabled)
    }

    public func resetAutoSyncEnabled(autoSyncKey: String) async {
        let store = autoSyncStore(for: autoSyncKey)
        await store.resetAutoSyncEnabled()
    }

    public func fetchPermissionState(for quantityIdentifier: HKQuantityTypeIdentifier) async -> HealthKitPermissionState {
        guard await isAvailable() else {
            return .unavailable()
        }

        guard let quantityType = quantityType(for: quantityIdentifier) else {
            return .unavailable()
        }

        let writeState: HealthKitAuthorizationState
        switch healthStore.authorizationStatus(for: quantityType) {
        case .sharingAuthorized:
            writeState = .authorized
        case .sharingDenied:
            writeState = .denied
        case .notDetermined:
            writeState = .notDetermined
        @unknown default:
            writeState = .notDetermined
        }

        let readState = await resolveReadAuthorizationState(for: quantityType)
        return HealthKitPermissionState(read: readState, write: writeState)
    }

    public func requestPermissions(for quantityIdentifier: HKQuantityTypeIdentifier) async -> HealthKitPermissionState {
        guard await isAvailable() else {
            return .unavailable()
        }

        guard let quantityType = quantityType(for: quantityIdentifier) else {
            return .unavailable()
        }

        do {
            try await requestAuthorization(for: quantityType)
        } catch {
            // Return the latest resolvable state instead of failing the UI flow.
        }

        return await fetchPermissionState(for: quantityIdentifier)
    }

    public func syncSampleIfEnabled(
        quantityIdentifier: HKQuantityTypeIdentifier,
        autoSyncKey: String,
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String? {
        guard await isAvailable() else { return nil }
        guard await fetchAutoSyncEnabled(autoSyncKey: autoSyncKey) else { return nil }
        guard let quantityType = quantityType(for: quantityIdentifier) else { return nil }

        guard healthStore.authorizationStatus(for: quantityType) == .sharingAuthorized else {
            return nil
        }

        return try await saveSample(
            quantityType: quantityType,
            value: value,
            unit: unit,
            start: start,
            end: end
        )
    }

    public func syncSample(
        quantityIdentifier: HKQuantityTypeIdentifier,
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String {
        guard await isAvailable() else {
            throw HealthKitServiceError.healthDataUnavailable
        }

        guard let quantityType = quantityType(for: quantityIdentifier) else {
            throw HealthKitServiceError.quantityTypeUnavailable
        }

        let permissionState = await fetchPermissionState(for: quantityIdentifier)
        guard permissionState.write == .authorized else {
            throw HealthKitServiceError.writeNotAuthorized
        }

        return try await saveSample(
            quantityType: quantityType,
            value: value,
            unit: unit,
            start: start,
            end: end
        )
    }

    private func quantityType(for quantityIdentifier: HKQuantityTypeIdentifier) -> HKQuantityType? {
        HKObjectType.quantityType(forIdentifier: quantityIdentifier)
    }

    private func autoSyncStore(for key: String) -> HealthKitAutoSyncPreferenceStore {
        if let existingStore = autoSyncStores[key] {
            return existingStore
        }

        let newStore = HealthKitAutoSyncPreferenceStore(key: key)
        autoSyncStores[key] = newStore
        return newStore
    }

    private func saveSample(
        quantityType: HKQuantityType,
        value: Double,
        unit: HKUnit,
        start: Date,
        end: Date
    ) async throws -> String {
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let sample = HKQuantitySample(type: quantityType, quantity: quantity, start: start, end: end)

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.save(sample) { _, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume(returning: ())
            }
        }

        return sample.uuid.uuidString
    }

    private func resolveReadAuthorizationState(for quantityType: HKQuantityType) async -> HealthKitAuthorizationState {
        let requestStatus = await fetchReadRequestStatus(for: quantityType)
        if requestStatus == .shouldRequest {
            return .notDetermined
        }

        let queryResult = await probeReadAuthorization(for: quantityType)
        switch queryResult {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .unavailable:
            return .unavailable
        @unknown default:
            return .notDetermined
        }
    }

    private func fetchReadRequestStatus(for quantityType: HKQuantityType) async -> HKAuthorizationRequestStatus {
        await withCheckedContinuation { continuation in
            healthStore.getRequestStatusForAuthorization(
                toShare: [quantityType],
                read: [quantityType]
            ) { status, _ in
                continuation.resume(returning: status)
            }
        }
    }

    private func probeReadAuthorization(for quantityType: HKQuantityType) async -> HealthKitAuthorizationState {
        await withCheckedContinuation { continuation in
            let predicate = HKQuery.predicateForSamples(
                withStart: Date.distantPast,
                end: Date(),
                options: [.strictStartDate]
            )

            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: nil
            ) { _, _, error in
                if let healthKitError = error as? HKError, healthKitError.code == .errorAuthorizationDenied {
                    continuation.resume(returning: .denied)
                    return
                }

                if error != nil {
                    continuation.resume(returning: .notDetermined)
                    return
                }

                continuation.resume(returning: .authorized)
            }

            healthStore.execute(query)
        }
    }

    private func requestAuthorization(for quantityType: HKQuantityType) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.requestAuthorization(
                toShare: [quantityType],
                read: [quantityType]
            ) { _, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                continuation.resume(returning: ())
            }
        }
    }
}
