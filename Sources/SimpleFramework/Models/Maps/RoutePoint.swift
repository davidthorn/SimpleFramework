//
//  RoutePoint.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation

/// A single recorded location sample in a workout route.
public struct RoutePoint: Codable, Hashable, Sendable {
    /// The latitude of the sample in decimal degrees.
    public let latitude: Double

    /// The longitude of the sample in decimal degrees.
    public let longitude: Double

    /// The altitude in meters.
    public let altitude: Double

    /// The instantaneous speed in meters per second.
    public let speedMetersPerSecond: Double

    /// The course heading in degrees.
    public let courseDegrees: Double

    /// The sample timestamp.
    public let timestamp: Date

    /// Creates a route sample.
    public init(
        latitude: Double,
        longitude: Double,
        altitude: Double,
        speedMetersPerSecond: Double,
        courseDegrees: Double,
        timestamp: Date
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.speedMetersPerSecond = speedMetersPerSecond
        self.courseDegrees = courseDegrees
        self.timestamp = timestamp
    }
}
