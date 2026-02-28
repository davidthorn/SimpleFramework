//
//  FormTextFieldRowStyle.swift
//  SimpleFramework
//
//  Created by David Thorn on 28.02.26.
//

import SwiftUI

public struct FormTextFieldRowStyle: Sendable {
    public let labelStyle: FormFieldLabelStyle
    public let contentSpacing: CGFloat
    public let textFont: Font
    public let textColor: Color
    public let placeholderFont: Font
    public let placeholderColor: Color
    public let validationFont: Font
    public let inputHorizontalPadding: CGFloat
    public let inputVerticalPadding: CGFloat
    public let minimumFieldHeight: CGFloat
    public let cornerRadius: CGFloat
    public let backgroundTopColor: Color
    public let backgroundBottomColor: Color
    public let borderLineWidth: CGFloat
    public let normalBorderColors: [Color]
    public let warningBorderColors: [Color]
    public let errorBorderColors: [Color]
    public let normalValidationColor: Color
    public let warningValidationColor: Color
    public let errorValidationColor: Color
    public let shadowColor: Color
    public let shadowRadius: CGFloat
    public let shadowYOffset: CGFloat

    public init(
        labelStyle: FormFieldLabelStyle,
        contentSpacing: CGFloat,
        textFont: Font,
        textColor: Color,
        placeholderFont: Font,
        placeholderColor: Color,
        validationFont: Font,
        inputHorizontalPadding: CGFloat,
        inputVerticalPadding: CGFloat,
        minimumFieldHeight: CGFloat,
        cornerRadius: CGFloat,
        backgroundTopColor: Color,
        backgroundBottomColor: Color,
        borderLineWidth: CGFloat,
        normalBorderColors: [Color],
        warningBorderColors: [Color],
        errorBorderColors: [Color],
        normalValidationColor: Color,
        warningValidationColor: Color,
        errorValidationColor: Color,
        shadowColor: Color,
        shadowRadius: CGFloat,
        shadowYOffset: CGFloat
    ) {
        self.labelStyle = labelStyle
        self.contentSpacing = contentSpacing
        self.textFont = textFont
        self.textColor = textColor
        self.placeholderFont = placeholderFont
        self.placeholderColor = placeholderColor
        self.validationFont = validationFont
        self.inputHorizontalPadding = inputHorizontalPadding
        self.inputVerticalPadding = inputVerticalPadding
        self.minimumFieldHeight = minimumFieldHeight
        self.cornerRadius = cornerRadius
        self.backgroundTopColor = backgroundTopColor
        self.backgroundBottomColor = backgroundBottomColor
        self.borderLineWidth = borderLineWidth
        self.normalBorderColors = normalBorderColors
        self.warningBorderColors = warningBorderColors
        self.errorBorderColors = errorBorderColors
        self.normalValidationColor = normalValidationColor
        self.warningValidationColor = warningValidationColor
        self.errorValidationColor = errorValidationColor
        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius
        self.shadowYOffset = shadowYOffset
    }

    public func borderColors(for validationState: FormFieldValidationState) -> [Color] {
        switch validationState {
        case .normal:
            return normalBorderColors
        case .warning:
            return warningBorderColors
        case .error:
            return errorBorderColors
        }
    }

    public func validationColor(for validationState: FormFieldValidationState) -> Color {
        switch validationState {
        case .normal:
            return normalValidationColor
        case .warning:
            return warningValidationColor
        case .error:
            return errorValidationColor
        }
    }

    public static let `default` = FormTextFieldRowStyle(
        labelStyle: .default,
        contentSpacing: 10,
        textFont: .body.weight(.medium),
        textColor: .primary,
        placeholderFont: .body,
        placeholderColor: .secondary.opacity(0.8),
        validationFont: .caption.weight(.medium),
        inputHorizontalPadding: 16,
        inputVerticalPadding: 14,
        minimumFieldHeight: 52,
        cornerRadius: 10,
        backgroundTopColor: .white.opacity(0.88),
        backgroundBottomColor: .primary.opacity(0.03),
        borderLineWidth: 1.25,
        normalBorderColors: [
            .accentColor.opacity(0.22),
            .primary.opacity(0.07)
        ],
        warningBorderColors: [
            .orange.opacity(0.34),
            .orange.opacity(0.12)
        ],
        errorBorderColors: [
            .red.opacity(0.40),
            .red.opacity(0.14)
        ],
        normalValidationColor: .secondary,
        warningValidationColor: .orange,
        errorValidationColor: .red,
        shadowColor: .black.opacity(0.08),
        shadowRadius: 10,
        shadowYOffset: 4
    )
}
