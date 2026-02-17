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

    public init(
        text: Binding<String>,
        title: String,
        placeholder: String,
        helperText: String? = nil
    ) {
        _text = text
        self.title = title
        self.placeholder = placeholder
        self.helperText = helperText
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            TextField(placeholder, text: $text)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(inputBackground)

            if let helperText {
                Text(helperText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.secondary.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
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

        var body: some View {
            SimpleLabeledTextFieldCard(
                text: $value,
                title: "Target Value",
                placeholder: "e.g. 70.0",
                helperText: "Use a decimal value if needed."
            )
            .padding()
        }
    }

    #Preview {
        SimpleLabeledTextFieldCardPreviewHost()
    }
#endif
