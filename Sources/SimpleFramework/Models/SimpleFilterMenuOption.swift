//
//  SimpleFilterMenuOption.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import Foundation

/// A selectable option displayed inside a filter menu section.
public struct SimpleFilterMenuOption: Identifiable {
    /// Stable identifier for the option.
    public let id: String

    /// The user-facing option title.
    public let title: String

    /// Indicates whether the option is currently selected.
    public let isSelected: Bool

    /// Executes when the user chooses the option.
    public let action: @Sendable () -> Void

    /// Creates a filter menu option.
    public init(
        id: String,
        title: String,
        isSelected: Bool,
        action: @escaping @Sendable () -> Void
    ) {
        self.id = id
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
}
