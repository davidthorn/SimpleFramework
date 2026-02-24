//
//  SimpleWorkoutHistoryRowView.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import SwiftUI

/// A reusable workout list item with route preview and text summary.
public struct SimpleWorkoutHistoryRowView: View {
    /// Row display model.
    public let row: SimpleWorkoutHistoryRow

    /// Tint used for map controls and accents.
    public let tint: Color

    /// Creates a workout history row view.
    public init(
        row: SimpleWorkoutHistoryRow,
        tint: Color = .accentColor
    ) {
        self.row = row
        self.tint = tint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if row.points.isEmpty {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.secondary.opacity(0.10))
                    .frame(height: 96)
                    .overlay {
                        Label("No Route Preview", systemImage: "figure.run")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
            } else {
                MapRouteView(
                    points: row.points,
                    currentPoint: nil,
                    showsUserLocation: false
                )
                .frame(height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .allowsHitTesting(false)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(row.title)
                    .font(.headline)
                Text(row.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
        )
        .padding(.vertical, 6)
    }
}

private extension Array where Element == RoutePoint {
    static var previewRoute: [RoutePoint] {
        let startDate = Date().addingTimeInterval(-1800)
        return [
            RoutePoint(
                latitude: 37.3346,
                longitude: -122.0090,
                altitude: 12,
                speedMetersPerSecond: 2.8,
                courseDegrees: 70,
                timestamp: startDate
            ),
            RoutePoint(
                latitude: 37.3360,
                longitude: -122.0055,
                altitude: 18,
                speedMetersPerSecond: 3.1,
                courseDegrees: 80,
                timestamp: startDate.addingTimeInterval(600)
            ),
            RoutePoint(
                latitude: 37.3385,
                longitude: -122.0020,
                altitude: 20,
                speedMetersPerSecond: 2.9,
                courseDegrees: 92,
                timestamp: startDate.addingTimeInterval(1200)
            )
        ]
    }
}

#if DEBUG
#Preview {
    SimpleWorkoutHistoryRowView(
        row: SimpleWorkoutHistoryRow(
            id: UUID(),
            title: "14 Feb 2026 at 10:10",
            subtitle: "4.20 km • 30 min",
            points: .previewRoute
        )
    )
    .padding()
}
#endif
