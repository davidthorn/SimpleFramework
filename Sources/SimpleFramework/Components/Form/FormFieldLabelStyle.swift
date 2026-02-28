//
//  FormFieldLabelStyle.swift
//  SimpleFramework
//
//  Created by David Thorn on 28.02.26.
//

import SwiftUI

public struct FormFieldLabelStyle: Sendable {
    public let spacing: CGFloat
    public let titleFont: Font
    public let titleColor: Color
    public let descriptionFont: Font
    public let descriptionColor: Color
    public let trailingLabelFont: Font
    public let trailingLabelTextColor: Color
    public let trailingLabelBackgroundColor: Color
    public let trailingLabelHorizontalPadding: CGFloat
    public let trailingLabelVerticalPadding: CGFloat

    public init(
        spacing: CGFloat,
        titleFont: Font,
        titleColor: Color,
        descriptionFont: Font,
        descriptionColor: Color,
        trailingLabelFont: Font,
        trailingLabelTextColor: Color,
        trailingLabelBackgroundColor: Color,
        trailingLabelHorizontalPadding: CGFloat,
        trailingLabelVerticalPadding: CGFloat
    ) {
        self.spacing = spacing
        self.titleFont = titleFont
        self.titleColor = titleColor
        self.descriptionFont = descriptionFont
        self.descriptionColor = descriptionColor
        self.trailingLabelFont = trailingLabelFont
        self.trailingLabelTextColor = trailingLabelTextColor
        self.trailingLabelBackgroundColor = trailingLabelBackgroundColor
        self.trailingLabelHorizontalPadding = trailingLabelHorizontalPadding
        self.trailingLabelVerticalPadding = trailingLabelVerticalPadding
    }

    public static let `default` = FormFieldLabelStyle(
        spacing: 6,
        titleFont: .headline,
        titleColor: .primary,
        descriptionFont: .caption,
        descriptionColor: .secondary,
        trailingLabelFont: .caption,
        trailingLabelTextColor: .secondary,
        trailingLabelBackgroundColor: .secondary.opacity(0.12),
        trailingLabelHorizontalPadding: 6,
        trailingLabelVerticalPadding: 2
    )
}
