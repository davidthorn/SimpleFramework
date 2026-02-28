//
//  FormTextFieldRowView.swift
//  SimpleFramework
//
//  Created by David Thorn on 28.02.26.
//

import SwiftUI

public struct FormTextFieldRowView: View {
    internal let title: String
    internal let description: String
    internal let trailingLabel: String?
    internal let placeholder: String
    internal let validationMessage: String?
    internal let validationState: FormFieldValidationState
    internal let style: FormTextFieldRowStyle
    @Binding internal var text: String

    public init(
        title: String,
        description: String,
        trailingLabel: String? = nil,
        placeholder: String,
        validationMessage: String? = nil,
        validationState: FormFieldValidationState = .normal,
        style: FormTextFieldRowStyle = .default,
        text: Binding<String>
    ) {
        self.title = title
        self.description = description
        self.trailingLabel = trailingLabel
        self.placeholder = placeholder
        self.validationMessage = validationMessage
        self.validationState = validationState
        self.style = style
        self._text = text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: style.contentSpacing) {
            FormFieldLabelView(
                title: title,
                description: description,
                trailingLabel: trailingLabel,
                style: style.labelStyle
            )

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder)
                    .font(style.placeholderFont)
                    .foregroundColor(style.placeholderColor)
            )
                .font(style.textFont)
                .foregroundStyle(style.textColor)
                .textFieldStyle(.plain)
                .padding(.horizontal, style.inputHorizontalPadding)
                .padding(.vertical, style.inputVerticalPadding)
                .frame(minHeight: style.minimumFieldHeight)
                .background(inputBackground)
                .overlay(inputBorder)
                .shadow(color: style.shadowColor, radius: style.shadowRadius, y: style.shadowYOffset)

            if let validationMessage, validationMessage.isEmpty == false {
                Text(validationMessage)
                    .font(style.validationFont)
                    .foregroundStyle(style.validationColor(for: validationState))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        style.backgroundTopColor,
                        style.backgroundBottomColor
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }

    private var inputBorder: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius, style: .continuous)
            .strokeBorder(
                LinearGradient(
                    colors: style.borderColors(for: validationState),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: style.borderLineWidth
            )
    }
}

#if DEBUG
#Preview {
    ScrollView {
        VStack(spacing: 20) {
            FormTextFieldRowView(
                title: "Food ID",
                description: "Unique item key used by all CSV relations.",
                trailingLabel: "slug",
                placeholder: "e.g. food.apple.raw",
                text: .constant("food.apple.raw")
            )
            
            FormTextFieldRowView(
                title: "Reference Value",
                description: "Numeric amount used as the serving baseline for all nutrient values.",
                trailingLabel: "number",
                placeholder: "e.g. 100",
                validationMessage: "Reference value should usually be a positive numeric amount.",
                validationState: .warning,
                text: .constant("0")
            )
            
            FormTextFieldRowView(
                title: "Primary Name",
                description: "Human-readable food name displayed in item lists.",
                trailingLabel: "text",
                placeholder: "e.g. Apple, raw",
                validationMessage: "Primary name is required.",
                validationState: .error,
                text: .constant("")
            )
            
            FormTextFieldRowView(
                title: "Custom Style",
                description: "This preview uses a fully customized style object.",
                trailingLabel: "custom",
                placeholder: "e.g. Styled value",
                style: FormTextFieldRowStyle(
                    labelStyle: FormFieldLabelStyle(
                        spacing: 8,
                        titleFont: .title3.weight(.semibold),
                        titleColor: .brown,
                        descriptionFont: .footnote,
                        descriptionColor: .brown.opacity(0.7),
                        trailingLabelFont: .footnote.weight(.bold),
                        trailingLabelTextColor: .white,
                        trailingLabelBackgroundColor: .brown.opacity(0.8),
                        trailingLabelHorizontalPadding: 8,
                        trailingLabelVerticalPadding: 3
                    ),
                    contentSpacing: 12,
                    textFont: .title3.weight(.medium),
                    textColor: .brown,
                    placeholderFont: .callout,
                    placeholderColor: .brown.opacity(0.4),
                    validationFont: .footnote.weight(.semibold),
                    inputHorizontalPadding: 18,
                    inputVerticalPadding: 16,
                    minimumFieldHeight: 56,
                    cornerRadius: 14,
                    backgroundTopColor: Color(red: 0.99, green: 0.95, blue: 0.88),
                    backgroundBottomColor: Color(red: 0.96, green: 0.90, blue: 0.80),
                    borderLineWidth: 1.5,
                    normalBorderColors: [.brown.opacity(0.35), .brown.opacity(0.12)],
                    warningBorderColors: [.orange.opacity(0.45), .orange.opacity(0.20)],
                    errorBorderColors: [.red.opacity(0.45), .red.opacity(0.20)],
                    normalValidationColor: .brown.opacity(0.7),
                    warningValidationColor: .orange,
                    errorValidationColor: .red,
                    shadowColor: .brown.opacity(0.14),
                    shadowRadius: 12,
                    shadowYOffset: 5
                ),
                text: .constant("Styled")
            )
            Spacer()
        }
        .padding()
    }
}
#endif
