//
//  RouteStatItem.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import Foundation

/// A display-ready key/value statistic used in route overlays.
public struct RouteStatItem: Hashable, Sendable {
    /// The statistic title.
    public let title: String

    /// The statistic value.
    public let value: String

    /// Creates a statistic item.
    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
