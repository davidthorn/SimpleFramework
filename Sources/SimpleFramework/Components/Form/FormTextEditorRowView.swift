//
//  FormTextEditorRowView.swift
//  SimpleFramework
//
//  Created by David Thorn on 01.03.2026.
//

import SwiftUI

public struct FormTextEditorRowView: View {
    internal let title: String
    internal let description: String?
    internal let trailingLabel: String?
    internal let placeholder: String
    internal let validationMessage: String?
    internal let validationState: FormFieldValidationState
    internal let style: FormTextEditorRowStyle
    @Binding internal var text: String

    public init(
        title: String,
        description: String? = nil,
        trailingLabel: String? = nil,
        placeholder: String,
        validationMessage: String? = nil,
        validationState: FormFieldValidationState = .normal,
        style: FormTextEditorRowStyle = .default,
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

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(style.placeholderFont)
                        .foregroundColor(style.placeholderColor)
                        .padding(.horizontal, style.inputHorizontalPadding)
                        .padding(.vertical, style.inputVerticalPadding)
                }

                TextEditor(text: $text)
                    .font(style.textFont)
                    .foregroundStyle(style.textColor)
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal, style.inputHorizontalPadding - 5)
                    .padding(.vertical, style.inputVerticalPadding - 8)
                    .frame(minHeight: style.minimumEditorHeight)
            }
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
            FormTextEditorRowView(
                title: "Notes",
                description: "Use notes to capture the extra context that makes a task easier to start.",
                trailingLabel: "optional",
                placeholder: "Anything that helps you act on this task.",
                text: .constant("Keep this short and practical.")
            )

            FormTextEditorRowView(
                title: "Blockers",
                description: "Call out friction clearly so it can be removed.",
                trailingLabel: "multiline",
                placeholder: "What is getting in the way?",
                validationMessage: "This field is currently empty.",
                validationState: .warning,
                text: .constant("")
            )
        }
        .padding()
    }
}
#endif
