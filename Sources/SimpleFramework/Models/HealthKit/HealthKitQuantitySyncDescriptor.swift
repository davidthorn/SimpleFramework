//
//  HealthKitQuantitySyncDescriptor.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import HealthKit

/// Defines a reusable configuration for a specific HealthKit quantity sync domain.
public struct HealthKitQuantitySyncDescriptor: Hashable, Sendable {
    /// HealthKit quantity type identifier used for permissions and sample writes.
    public let quantityIdentifier: HKQuantityTypeIdentifier
    /// Stable provider identifier used in sync metadata records.
    public let providerIdentifier: String
    /// Preference key used to persist and observe the auto-sync flag.
    public let autoSyncKey: String

    /// Creates a quantity sync descriptor.
    public init(
        quantityIdentifier: HKQuantityTypeIdentifier,
        providerIdentifier: String,
        autoSyncKey: String
    ) {
        self.quantityIdentifier = quantityIdentifier
        self.providerIdentifier = providerIdentifier
        self.autoSyncKey = autoSyncKey
    }
}
