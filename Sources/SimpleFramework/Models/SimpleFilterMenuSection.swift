//
//  SimpleFilterMenuSection.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import Foundation

/// A titled section of selectable filter menu options.
public struct SimpleFilterMenuSection: Identifiable {
    /// Stable identifier for the section.
    public let id: String

    /// The section title displayed in the menu.
    public let title: String

    /// The options shown in this section.
    public let options: [SimpleFilterMenuOption]

    /// Creates a filter menu section.
    public init(
        id: String,
        title: String,
        options: [SimpleFilterMenuOption]
    ) {
        self.id = id
        self.title = title
        self.options = options
    }
}
