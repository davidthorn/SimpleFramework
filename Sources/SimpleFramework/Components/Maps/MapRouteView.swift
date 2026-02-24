//
//  MapRouteView.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import CoreLocation
import MapKit
import SwiftUI

/// A route map with polyline and start/finish markers.
public struct MapRouteView: View {
    /// Ordered route points.
    public let points: [RoutePoint]

    /// The active point that should be highlighted on the map.
    public let currentPoint: RoutePoint?

    /// Whether the user location indicator should be rendered.
    public let showsUserLocation: Bool

    /// When true, user camera gestures prevent automatic refit.
    public let preservesUserCameraAfterInteraction: Bool

    @State private var cameraPosition: MapCameraPosition
    @State private var hasUserAdjustedCamera: Bool

    /// Creates a route map.
    public init(
        points: [RoutePoint],
        currentPoint: RoutePoint?,
        showsUserLocation: Bool = true,
        preservesUserCameraAfterInteraction: Bool = false
    ) {
        self.points = points
        self.currentPoint = currentPoint
        self.showsUserLocation = showsUserLocation
        self.preservesUserCameraAfterInteraction = preservesUserCameraAfterInteraction
        self._cameraPosition = State(initialValue: .automatic)
        self._hasUserAdjustedCamera = State(initialValue: false)
    }

    public var body: some View {
        Group {
            if shouldShowLocationPlaceholder {
                CoreLocationLoadingPlaceholderView()
            } else {
                Map(position: $cameraPosition) {
                    if showsUserLocation {
                        UserAnnotation()
                    }

                    if points.count > 1 {
                        MapPolyline(coordinates: polylineCoordinates)
                            .stroke(.blue, lineWidth: 4)
                    }

                    if let startPoint = points.first {
                        Annotation(
                            "Start",
                            coordinate: CLLocationCoordinate2D(
                                latitude: startPoint.latitude,
                                longitude: startPoint.longitude
                            )
                        ) {
                            Image(systemName: "flag.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.green)
                                .padding(2)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }

                    if points.count > 1, let endPoint = points.last {
                        Annotation(
                            "Finish",
                            coordinate: CLLocationCoordinate2D(
                                latitude: endPoint.latitude,
                                longitude: endPoint.longitude
                            )
                        ) {
                            Image(systemName: "flag.checkered.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.red)
                                .padding(2)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }

                    if let currentPoint {
                        Annotation(
                            "Current",
                            coordinate: CLLocationCoordinate2D(
                                latitude: currentPoint.latitude,
                                longitude: currentPoint.longitude
                            )
                        ) {
                            Image(systemName: "figure.run.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.red)
                                .padding(4)
                                .background(.ultraThinMaterial, in: Circle())
                        }
                    }
                }
                .mapStyle(.standard)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged { _ in
                            if preservesUserCameraAfterInteraction {
                                hasUserAdjustedCamera = true
                            }
                        }
                )
                .simultaneousGesture(
                    MagnificationGesture()
                        .onChanged { _ in
                            if preservesUserCameraAfterInteraction {
                                hasUserAdjustedCamera = true
                            }
                        }
                )
                .onAppear {
                    fitCameraIfNeeded(animated: false)
                }
                .onChange(of: points.count) { _, _ in
                    if shouldAutoFitCamera {
                        fitCameraIfNeeded(animated: true)
                    }
                }
                .onChange(of: currentPoint?.timestamp) { _, _ in
                    if shouldAutoFitCamera {
                        fitCameraIfNeeded(animated: true)
                    }
                }
            }
        }
    }

    private var shouldAutoFitCamera: Bool {
        if preservesUserCameraAfterInteraction == false {
            return true
        }

        return hasUserAdjustedCamera == false
    }

    private var shouldShowLocationPlaceholder: Bool {
        showsUserLocation && points.isEmpty && currentPoint == nil
    }

    private var polylineCoordinates: [CLLocationCoordinate2D] {
        points.map { point in
            CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
        }
    }

    private func fitCameraIfNeeded(animated: Bool) {
        if points.isEmpty {
            guard let currentPoint else {
                setCameraPosition(.automatic, animated: animated)
                return
            }

            let center = CLLocationCoordinate2D(
                latitude: currentPoint.latitude,
                longitude: currentPoint.longitude
            )
            setCameraPosition(
                .region(
                    MKCoordinateRegion(
                        center: center,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                ),
                animated: animated
            )
            return
        }

        if points.count == 1, let point = points.first {
            let center = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            setCameraPosition(
                .region(
                    MKCoordinateRegion(
                        center: center,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    )
                ),
                animated: animated
            )
            return
        }

        let coordinates = polylineCoordinates
        var minLatitude = coordinates[0].latitude
        var maxLatitude = coordinates[0].latitude
        var minLongitude = coordinates[0].longitude
        var maxLongitude = coordinates[0].longitude

        for coordinate in coordinates {
            minLatitude = min(minLatitude, coordinate.latitude)
            maxLatitude = max(maxLatitude, coordinate.latitude)
            minLongitude = min(minLongitude, coordinate.longitude)
            maxLongitude = max(maxLongitude, coordinate.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLatitude - minLatitude) * 1.4, 0.005),
            longitudeDelta: max((maxLongitude - minLongitude) * 1.4, 0.005)
        )

        setCameraPosition(.region(MKCoordinateRegion(center: center, span: span)), animated: animated)
    }

    private func setCameraPosition(_ position: MapCameraPosition, animated: Bool) {
        if animated {
            withAnimation(.easeInOut(duration: 0.45)) {
                cameraPosition = position
            }
        } else {
            cameraPosition = position
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
    MapRouteView(points: .previewRoute, currentPoint: Array.previewRoute.last)
}
#endif
