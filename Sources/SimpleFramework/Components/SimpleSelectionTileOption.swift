//
//  SimpleSelectionTileOption.swift
//  SimpleFramework
//
//  Created by David Thorn on 23.03.2026.
//

import SwiftUI

public struct SimpleSelectionTileOption<ID: Hashable>: Identifiable {
    public let id: ID
    public let title: String
    public let subtitle: String?
    public let tint: Color

    public init(
        id: ID,
        title: String,
        subtitle: String? = nil,
        tint: Color = .accentColor
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.tint = tint
    }
}

