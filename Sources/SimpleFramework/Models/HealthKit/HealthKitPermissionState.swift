//
//  HealthKitPermissionState.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

public struct HealthKitPermissionState: Codable, Hashable, Sendable {
    public let read: HealthKitAuthorizationState
    public let write: HealthKitAuthorizationState

    public init(read: HealthKitAuthorizationState, write: HealthKitAuthorizationState) {
        self.read = read
        self.write = write
    }

    public static func unavailable() -> HealthKitPermissionState {
        HealthKitPermissionState(read: .unavailable, write: .unavailable)
    }
}
