//
//  SimpleFilterMenuSection.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import Foundation

/// A titled section of selectable filter menu options.
///
/// Use sections to organize related menu filters such as time range, status, or sort order. Each section
/// should contain mutually related options that are easy to scan together.
public struct SimpleFilterMenuSection: Identifiable {
    /// Stable identifier for the section.
    public let id: String

    /// The section title displayed in the menu.
    public let title: String

    /// The options shown in this section.
    public let options: [SimpleFilterMenuOption]

    /// Creates a filter menu section.
    ///
    /// - Parameters:
    ///   - id: A stable identifier for the section.
    ///   - title: The title displayed above the section options.
    ///   - options: The selectable options contained in the section.
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
