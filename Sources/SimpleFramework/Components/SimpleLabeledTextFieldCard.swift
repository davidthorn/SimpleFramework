//
//  SimpleLabeledTextFieldCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleLabeledTextFieldCard: View {
    @Binding public var text: String

    public let title: String
    public let placeholder: String
    public let helperText: String?
    public let tint: Color
    public let isEnabled: Bool
    public let keyboardKind: FormKeyboardKind

    public init(
        text: Binding<String>,
        title: String,
        placeholder: String,
        helperText: String? = nil,
        tint: Color = .accentColor,
        isEnabled: Bool = true,
        keyboardKind: FormKeyboardKind = .default
    ) {
        _text = text
        self.title = title
        self.placeholder = placeholder
        self.helperText = helperText
        self.tint = tint
        self.isEnabled = isEnabled
        self.keyboardKind = keyboardKind
    }

    public var body: some View {
        FormTextFieldRowView(
            title: title.uppercased(),
            description: "",
            placeholder: placeholder,
            validationMessage: helperText,
            style: .simpleCard(tint: tint),
            keyboardKind: keyboardKind,
            isEnabled: isEnabled,
            text: $text
        )
        .padding(14)
        .background(cardBackground)
        .opacity(isEnabled ? 1 : 0.6)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.secondary.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(tint.opacity(0.2), lineWidth: 1)
            )
    }

}

#if DEBUG
    private struct SimpleLabeledTextFieldCardPreviewHost: View {
        @State private var value: String = "72.5"
        @State private var numericValue: String = "2500"

        var body: some View {
            VStack(spacing: 12) {
                SimpleLabeledTextFieldCard(
                    text: $value,
                    title: "Target Value",
                    placeholder: "e.g. 70.0",
                    helperText: "Use a decimal value if needed."
                )

                SimpleLabeledTextFieldCard(
                    numericText: $numericValue,
                    title: "Daily Goal",
                    placeholder: "ml",
                    helperText: "Numeric extension initializer.",
                    tint: .orange,
                    allowsDecimalInput: false
                )
            }
            .padding()
        }
    }

    #Preview {
        SimpleLabeledTextFieldCardPreviewHost()
    }
#endif

public extension SimpleLabeledTextFieldCard {
    init(
        numericText: Binding<String>,
        title: String,
        placeholder: String,
        helperText: String? = nil,
        tint: Color = .accentColor,
        isEnabled: Bool = true,
        allowsDecimalInput: Bool = false
    ) {
        self.init(
            text: numericText,
            title: title,
            placeholder: placeholder,
            helperText: helperText,
            tint: tint,
            isEnabled: isEnabled,
            keyboardKind: allowsDecimalInput ? .decimalPad : .numberPad
        )
    }
}
