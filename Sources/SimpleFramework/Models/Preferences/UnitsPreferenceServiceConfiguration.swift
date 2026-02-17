//
//  UnitsPreferenceServiceConfiguration.swift
//  SimpleFramework
//
//  Models/Preferences
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Configuration for persisting and restoring unit preferences.
public struct UnitsPreferenceServiceConfiguration: Sendable {
    /// UserDefaults key used to store the selected unit.
    public let unitKey: String
    /// Unit value used when no stored value exists.
    public let defaultUnit: SettingsVolumeUnit

    /// Creates a units-preference configuration.
    public init(
        unitKey: String = "settings.volume.unit",
        defaultUnit: SettingsVolumeUnit = .milliliters
    ) {
        self.unitKey = unitKey
        self.defaultUnit = defaultUnit
    }
}
