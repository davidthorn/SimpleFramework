//
//  SimpleWorkoutDetailMetricRow.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation

/// A display-ready metric row for workout detail sections.
public struct SimpleWorkoutDetailMetricRow: Hashable, Sendable {
    /// Label shown as the metric title.
    public let title: String

    /// Formatted value shown for the metric.
    public let value: String

    /// Optional SF Symbol shown next to the title.
    public let symbolName: String?

    /// Creates a workout detail metric row.
    public init(title: String, value: String, symbolName: String? = nil) {
        self.title = title
        self.value = value
        self.symbolName = symbolName
    }
}
