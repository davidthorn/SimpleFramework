//
//  SimpleElapsedHeroCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.03.2026.
//

import SwiftUI

public struct SimpleElapsedHeroCard<Content: View>: View {
    public let title: String
    public let subtitle: String
    public let elapsedText: String
    public let elapsedCaption: String
    public let emptyMessage: String?
    public let systemImage: String
    public let tint: Color
    private let content: Content

    public init(
        title: String,
        subtitle: String,
        elapsedText: String,
        elapsedCaption: String,
        emptyMessage: String?,
        systemImage: String,
        tint: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.elapsedText = elapsedText
        self.elapsedCaption = elapsedCaption
        self.emptyMessage = emptyMessage
        self.systemImage = systemImage
        self.tint = tint
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(tint)
                    .frame(width: 34, height: 34)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(tint.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            if let emptyMessage {
                Text(emptyMessage)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    Text(elapsedText)
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.primary)

                    Text(elapsedCaption)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }

            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(tint.opacity(0.22), lineWidth: 1)
                )
        )
    }
}

extension SimpleElapsedHeroCard where Content == EmptyView {
    public init(
        title: String,
        subtitle: String,
        elapsedText: String,
        elapsedCaption: String,
        emptyMessage: String?,
        systemImage: String,
        tint: Color
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            elapsedText: elapsedText,
            elapsedCaption: elapsedCaption,
            emptyMessage: emptyMessage,
            systemImage: systemImage,
            tint: tint
        ) {
            EmptyView()
        }
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 16) {
            SimpleElapsedHeroCard(
                title: "Last Change 10:24 AM",
                subtitle: "Logged at 10:24 AM",
                elapsedText: "01:15:42",
                elapsedCaption: "since last change",
                emptyMessage: nil,
                systemImage: "clock.badge.checkmark",
                tint: .orange
            )

            SimpleElapsedHeroCard(
                title: "Ready To Log",
                subtitle: "Ready to log a change.",
                elapsedText: "00:00:00",
                elapsedCaption: "since last change",
                emptyMessage: "Start tracking the latest nappy changes for today.",
                systemImage: "clock.badge.checkmark",
                tint: .orange
            )
        }
        .padding()
    }
#endif
