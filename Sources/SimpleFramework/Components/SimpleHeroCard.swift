//
//  SimpleHeroCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleHeroCard: View {
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
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        SimpleHeroCard(
            title: "Personalize",
            message: "Configure app behavior for your routine.",
            systemImage: "slider.horizontal.3",
            tint: .mint
        )
        .padding()
    }
#endif
