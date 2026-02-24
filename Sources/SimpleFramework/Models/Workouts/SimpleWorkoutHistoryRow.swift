//
//  SimpleWorkoutHistoryRow.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation

/// A display model for a workout item shown in history lists.
public struct SimpleWorkoutHistoryRow: Hashable, Sendable, Identifiable {
    /// Stable identifier for row diffing.
    public let id: UUID

    /// Primary label shown for the workout.
    public let title: String

    /// Secondary label shown for the workout.
    public let subtitle: String

    /// Route points used for the mini map preview.
    public let points: [RoutePoint]

    /// Creates a workout history row model.
    public init(
        id: UUID,
        title: String,
        subtitle: String,
        points: [RoutePoint]
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.points = points
    }
}
