//
//  SimpleLabeledTextEditorCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 02.03.2026.
//

import SwiftUI

public struct SimpleLabeledTextEditorCard: View {
    @Binding public var text: String

    public let title: String
    public let placeholder: String
    public let helperText: String?
    public let tint: Color

    public init(
        text: Binding<String>,
        title: String,
        placeholder: String,
        helperText: String? = nil,
        tint: Color = .accentColor
    ) {
        _text = text
        self.title = title
        self.placeholder = placeholder
        self.helperText = helperText
        self.tint = tint
    }

    public var body: some View {
        FormTextEditorRowView(
            title: title.uppercased(),
            placeholder: placeholder,
            validationMessage: helperText,
            style: .simpleCard(tint: tint),
            text: $text
        )
        .padding(14)
        .background(cardBackground)
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
    private struct SimpleLabeledTextEditorCardPreviewHost: View {
        @State private var notes: String = "Break this down into a first small step."

        var body: some View {
            SimpleLabeledTextEditorCard(
                text: $notes,
                title: "Notes",
                placeholder: "Anything that helps you start or finish this task.",
                helperText: "Use notes for context, next steps, or anything that reduces friction."
            )
            .padding()
        }
    }

    #Preview {
        SimpleLabeledTextEditorCardPreviewHost()
    }
#endif
