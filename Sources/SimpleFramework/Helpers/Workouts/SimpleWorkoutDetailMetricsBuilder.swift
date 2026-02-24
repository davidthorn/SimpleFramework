//
//  SimpleWorkoutDetailMetricsBuilder.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation

/// Builds display rows for workout detail metrics from raw source values.
public struct SimpleWorkoutDetailMetricsBuilder: Sendable {
    /// Creates a builder.
    public init() {}

    /// Builds ordered metric rows and source rows.
    /// - Parameter source: Raw workout values.
    /// - Returns: Tuple of primary metrics and source metadata rows.
    public func build(from source: SimpleWorkoutMetricsSource) -> (primaryRows: [SimpleWorkoutDetailMetricRow], sourceRows: [SimpleWorkoutDetailMetricRow]) {
        var primaryRows: [SimpleWorkoutDetailMetricRow] = []
        var sourceRows: [SimpleWorkoutDetailMetricRow] = []

        if let durationSeconds = source.durationSeconds {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Duration",
                    value: durationText(from: durationSeconds),
                    symbolName: "timer"
                )
            )
        }

        if let distance = source.totalDistanceMeters {
            let kilometers = distance / 1000
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Distance",
                    value: "\(kilometers.formatted(.number.precision(.fractionLength(2)))) km",
                    symbolName: "map"
                )
            )
        }

        if let energy = source.totalEnergyBurnedKilocalories {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Energy",
                    value: "\(energy.formatted(.number.precision(.fractionLength(0)))) kcal",
                    symbolName: "flame"
                )
            )
        }

        if let elevation = source.totalElevationGainMeters {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Elevation",
                    value: "\(elevation.formatted(.number.precision(.fractionLength(0)))) m",
                    symbolName: "mountain.2"
                )
            )
        }

        if let condition = source.weatherCondition {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Weather",
                    value: condition,
                    symbolName: source.weatherConditionSymbolName
                )
            )
        }

        if let temperature = source.weatherTemperatureCelsius {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Temperature",
                    value: "\(temperature.formatted(.number.precision(.fractionLength(1)))) °C",
                    symbolName: "thermometer"
                )
            )
        }

        if let humidity = source.weatherHumidityPercent {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Humidity",
                    value: "\(humidity.formatted(.number.precision(.fractionLength(0))))%",
                    symbolName: "drop"
                )
            )
        }

        if let location = locationLabel(for: source.locationTypeRawValue) {
            primaryRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Location",
                    value: location,
                    symbolName: "location"
                )
            )
        }

        if let sourceName = source.sourceName {
            sourceRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Source",
                    value: sourceName,
                    symbolName: "app"
                )
            )
        }

        if let deviceName = source.deviceName {
            sourceRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Device",
                    value: deviceName,
                    symbolName: "iphone"
                )
            )
        }

        if let bundleIdentifier = source.sourceBundleIdentifier {
            sourceRows.append(
                SimpleWorkoutDetailMetricRow(
                    title: "Bundle ID",
                    value: bundleIdentifier,
                    symbolName: "link"
                )
            )
        }

        return (primaryRows: primaryRows, sourceRows: sourceRows)
    }

    private func durationText(from seconds: TimeInterval) -> String {
        let totalSeconds = Int(seconds.rounded())
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let remainingSeconds = totalSeconds % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m \(remainingSeconds)s"
        }

        if minutes > 0 {
            return "\(minutes)m \(remainingSeconds)s"
        }

        return "\(remainingSeconds)s"
    }

    private func locationLabel(for rawValue: Int?) -> String? {
        switch rawValue {
        case 1: return "Indoor"
        case 2: return "Outdoor"
        case 0: return "Unknown"
        default: return nil
        }
    }
}
