//
//  SimpleLabeledTextFieldCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleLabeledTextFieldCard: View {
    public enum KeyboardKind: Sendable {
        case `default`
        case numberPad
        case decimalPad
    }

    @Binding public var text: String

    public let title: String
    public let placeholder: String
    public let helperText: String?
    public let tint: Color
    public let isEnabled: Bool
    public let keyboardKind: KeyboardKind

    public init(
        text: Binding<String>,
        title: String,
        placeholder: String,
        helperText: String? = nil,
        tint: Color = .accentColor,
        isEnabled: Bool = true,
        keyboardKind: KeyboardKind = .default
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
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            textField
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(inputBackground)
                .disabled(isEnabled == false)

            if let helperText {
                Text(helperText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(cardBackground)
        .opacity(isEnabled ? 1 : 0.6)
    }

    @ViewBuilder
    private var textField: some View {
        #if canImport(UIKit)
            switch keyboardKind {
            case .default:
                TextField(placeholder, text: $text)
            case .numberPad:
                TextField(placeholder, text: $text)
                    .keyboardType(.numberPad)
            case .decimalPad:
                TextField(placeholder, text: $text)
                    .keyboardType(.decimalPad)
            }
        #else
            TextField(placeholder, text: $text)
        #endif
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.secondary.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(tint.opacity(0.2), lineWidth: 1)
            )
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.white.opacity(0.75))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
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
