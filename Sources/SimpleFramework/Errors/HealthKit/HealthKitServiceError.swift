//
//  HealthKitServiceError.swift
//  SimpleFramework
//
//  Errors/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

public enum HealthKitServiceError: LocalizedError, Sendable {
    case healthDataUnavailable
    case quantityTypeUnavailable
    case writeNotAuthorized

    public var errorDescription: String? {
        switch self {
        case .healthDataUnavailable:
            return "Health data is unavailable on this device."
        case .quantityTypeUnavailable:
            return "The requested HealthKit quantity type is unavailable."
        case .writeNotAuthorized:
            return "HealthKit write access is not authorized."
        }
    }
}
