//
//  UnitsPreferenceServiceProtocol.swift
//  SimpleFramework
//
//  Protocols/Preferences
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines persistence and observation APIs for selected volume units.
public protocol UnitsPreferenceServiceProtocol: Sendable {
    /// Provides selected-unit updates, including the current value on subscription.
    func observeUnit() async -> AsyncStream<SettingsVolumeUnit>
    /// Returns the current selected unit.
    func fetchUnit() async -> SettingsVolumeUnit
    /// Persists a new selected unit and publishes it.
    func updateUnit(_ unit: SettingsVolumeUnit) async
    /// Clears persisted selection and publishes the default unit.
    func resetUnit() async
}
