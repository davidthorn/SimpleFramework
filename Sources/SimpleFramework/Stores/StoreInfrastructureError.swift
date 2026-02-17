//
//  StoreInfrastructureError.swift
//  SimpleFramework
//
//  Stores
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Infrastructure errors emitted by generic JSON store dependencies.
public enum StoreInfrastructureError: Error {
    /// Documents directory URL could not be resolved.
    case documentsDirectoryUnavailable
}
