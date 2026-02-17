//
//  HealthKitSyncMetadataStoreError.swift
//  SimpleFramework
//
//  Errors/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Errors thrown by the HealthKit sync metadata store.
public enum HealthKitSyncMetadataStoreError: Error, Sendable {
    /// The app documents directory is unavailable.
    case documentsDirectoryUnavailable
}
