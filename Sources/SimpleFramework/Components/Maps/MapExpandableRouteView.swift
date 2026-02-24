//
//  MapExpandableRouteView.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation
import SwiftUI

/// A map component that can expand into a full-screen route view.
public struct MapExpandableRouteView: View {
    /// Ordered route points.
    public let points: [RoutePoint]

    /// The active point that should be highlighted on the map.
    public let currentPoint: RoutePoint?

    /// Whether the user location indicator should be rendered.
    public let showsUserLocation: Bool

    /// Statistics shown in the full-screen overlay.
    public let overlayStats: [RouteStatItem]

    /// Height used by the collapsed map.
    public let collapsedHeight: CGFloat

    /// Tint color used by controls.
    public let tint: Color

    @State private var isFullScreenPresented: Bool
    @State private var isStatsOverlayVisible: Bool

    /// Creates an expandable route map.
    public init(
        points: [RoutePoint],
        currentPoint: RoutePoint?,
        showsUserLocation: Bool = false,
        overlayStats: [RouteStatItem] = [],
        collapsedHeight: CGFloat = 320,
        tint: Color = .accentColor
    ) {
        self.points = points
        self.currentPoint = currentPoint
        self.showsUserLocation = showsUserLocation
        self.overlayStats = overlayStats
        self.collapsedHeight = collapsedHeight
        self.tint = tint
        self._isFullScreenPresented = State(initialValue: false)
        self._isStatsOverlayVisible = State(initialValue: true)
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            MapRouteView(
                points: points,
                currentPoint: currentPoint,
                showsUserLocation: showsUserLocation
            )
            .frame(height: collapsedHeight)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .allowsHitTesting(false)

            Button {
                isStatsOverlayVisible = true
                isFullScreenPresented = true
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.headline)
            }
            .buttonStyle(.bordered)
            .tint(tint)
            .background(.ultraThinMaterial, in: Circle())
            .padding(12)
            .accessibilityLabel("Open map full screen")
        }
        .sheet(isPresented: $isFullScreenPresented) {
            expandedMapContent
        }
    }

    @ViewBuilder
    private var expandedMapContent: some View {
        ZStack {
            MapRouteView(
                points: points,
                currentPoint: currentPoint,
                showsUserLocation: showsUserLocation,
                preservesUserCameraAfterInteraction: true
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        isFullScreenPresented = false
                    } label: {
                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                            .font(.headline)
                    }
                    .buttonStyle(.bordered)
                    .tint(tint)
                    .background(.ultraThinMaterial, in: Circle())
                    .accessibilityLabel("Minimize map")
                }

                Spacer()

                if overlayStats.isEmpty == false {
                    if isStatsOverlayVisible {
                        MapStatsOverlayView(items: overlayStats) {
                            isStatsOverlayVisible = false
                        }
                    } else {
                        HStack {
                            Spacer()
                            Button {
                                isStatsOverlayVisible = true
                            } label: {
                                Label("Show Stats", systemImage: "chart.xyaxis.line")
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(tint)
                        }
                    }
                }
            }
            .padding()
        }
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
    MapExpandableRouteView(points: .previewRoute, currentPoint: Array.previewRoute.last)
}
#endif
