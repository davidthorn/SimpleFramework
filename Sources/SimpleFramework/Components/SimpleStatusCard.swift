//
//  SimpleStatusCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleStatusCard: View {
    public let title: String
    public let message: String
    public let systemImage: String
    public let tint: Color

    public init(
        title: String,
        message: String,
        systemImage: String,
        tint: Color = .accentColor
    ) {
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 12) {
            SimpleStatusCard(
                title: "Permission Needed",
                message: "Grant access to continue.",
                systemImage: "lock.shield.fill",
                tint: .orange
            )
            SimpleStatusCard(
                title: "All Good",
                message: "Everything is working as expected.",
                systemImage: "checkmark.seal.fill",
                tint: .green
            )
        }
        .padding()
    }
#endif
