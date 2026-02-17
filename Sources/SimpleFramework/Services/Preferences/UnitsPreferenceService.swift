//
//  UnitsPreferenceService.swift
//  SimpleFramework
//
//  Services/Preferences
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Actor-backed UserDefaults implementation for selected volume units.
public actor UnitsPreferenceService: UnitsPreferenceServiceProtocol {
    private let userDefaults: UserDefaults
    private let configuration: UnitsPreferenceServiceConfiguration
    private var continuations: [UUID: AsyncStream<SettingsVolumeUnit>.Continuation]

    /// Creates a units preference service.
    public init(
        configuration: UnitsPreferenceServiceConfiguration = UnitsPreferenceServiceConfiguration(),
        userDefaults: UserDefaults = .standard
    ) {
        self.configuration = configuration
        self.userDefaults = userDefaults
        continuations = [:]
    }

    /// Provides selected-unit updates.
    public func observeUnit() async -> AsyncStream<SettingsVolumeUnit> {
        let streamPair = AsyncStream<SettingsVolumeUnit>.makeStream()
        let id = UUID()
        continuations[id] = streamPair.continuation
        streamPair.continuation.onTermination = { [weak self] _ in
            guard let self else {
                return
            }
            Task {
                await self.removeContinuation(id: id)
            }
        }

        let current = await fetchUnit()
        streamPair.continuation.yield(current)
        return streamPair.stream
    }

    /// Returns current selected unit.
    public func fetchUnit() async -> SettingsVolumeUnit {
        guard let rawValue = userDefaults.string(forKey: configuration.unitKey) else {
            return configuration.defaultUnit
        }
        return SettingsVolumeUnit(rawValue: rawValue) ?? configuration.defaultUnit
    }

    /// Persists and publishes selected unit.
    public func updateUnit(_ unit: SettingsVolumeUnit) async {
        userDefaults.set(unit.rawValue, forKey: configuration.unitKey)
        publish(unit)
    }

    /// Clears persisted unit and publishes default.
    public func resetUnit() async {
        userDefaults.removeObject(forKey: configuration.unitKey)
        publish(configuration.defaultUnit)
    }

    private func removeContinuation(id: UUID) {
        continuations.removeValue(forKey: id)
    }

    private func publish(_ unit: SettingsVolumeUnit) {
        for continuation in continuations.values {
            continuation.yield(unit)
        }
    }
}
