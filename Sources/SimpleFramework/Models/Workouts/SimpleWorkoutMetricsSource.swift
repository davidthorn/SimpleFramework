//
//  SimpleWorkoutMetricsSource.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation

/// Raw workout values used to build detail metric rows.
public struct SimpleWorkoutMetricsSource: Hashable, Sendable {
    /// Workout duration in seconds.
    public let durationSeconds: TimeInterval?

    /// Total traveled distance in meters.
    public let totalDistanceMeters: Double?

    /// Total burned energy in kilocalories.
    public let totalEnergyBurnedKilocalories: Double?

    /// Total elevation gain in meters.
    public let totalElevationGainMeters: Double?

    /// Optional weather condition text.
    public let weatherCondition: String?

    /// Optional SF Symbol for weather condition.
    public let weatherConditionSymbolName: String?

    /// Optional weather temperature in Celsius.
    public let weatherTemperatureCelsius: Double?

    /// Optional humidity percentage.
    public let weatherHumidityPercent: Double?

    /// Optional workout location raw value.
    public let locationTypeRawValue: Int?

    /// Source app display name.
    public let sourceName: String?

    /// Source device display name.
    public let deviceName: String?

    /// Source bundle identifier.
    public let sourceBundleIdentifier: String?

    /// Creates a source container for workout metrics.
    public init(
        durationSeconds: TimeInterval? = nil,
        totalDistanceMeters: Double? = nil,
        totalEnergyBurnedKilocalories: Double? = nil,
        totalElevationGainMeters: Double? = nil,
        weatherCondition: String? = nil,
        weatherConditionSymbolName: String? = nil,
        weatherTemperatureCelsius: Double? = nil,
        weatherHumidityPercent: Double? = nil,
        locationTypeRawValue: Int? = nil,
        sourceName: String? = nil,
        deviceName: String? = nil,
        sourceBundleIdentifier: String? = nil
    ) {
        self.durationSeconds = durationSeconds
        self.totalDistanceMeters = totalDistanceMeters
        self.totalEnergyBurnedKilocalories = totalEnergyBurnedKilocalories
        self.totalElevationGainMeters = totalElevationGainMeters
        self.weatherCondition = weatherCondition
        self.weatherConditionSymbolName = weatherConditionSymbolName
        self.weatherTemperatureCelsius = weatherTemperatureCelsius
        self.weatherHumidityPercent = weatherHumidityPercent
        self.locationTypeRawValue = locationTypeRawValue
        self.sourceName = sourceName
        self.deviceName = deviceName
        self.sourceBundleIdentifier = sourceBundleIdentifier
    }
}
