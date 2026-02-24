//
//  SimpleToastCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 24.02.2026.
//

import SwiftUI

public struct SimpleToastCard: View {
    public let message: String
    public let systemImage: String
    public let tint: Color

    public init(
        message: String,
        systemImage: String,
        tint: Color = .accentColor
    ) {
        self.message = message
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(tint)

            Text(message)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Confirmation")
        .accessibilityValue(message)
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 10) {
            SimpleToastCard(
                message: "Saved successfully.",
                systemImage: "checkmark.circle.fill",
                tint: .green
            )
            SimpleToastCard(
                message: "Action failed.",
                systemImage: "xmark.octagon.fill",
                tint: .red
            )
        }
        .padding()
    }
#endif
