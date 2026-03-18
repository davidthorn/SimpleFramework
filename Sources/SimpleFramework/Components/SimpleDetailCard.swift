//
//  SimpleDetailCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import SwiftUI

/// A reusable, self-styled card container for detail content.
///
/// Use `SimpleDetailCard` when the content itself should live inside a rounded card with its own background
/// and border. Unlike `SimpleContentSection`, this type adds card chrome. Unlike `SimpleRouteGroup`,
/// it is not specifically for grouped navigation rows.
public struct SimpleDetailCard<Content: View>: View {
    private let title: String?
    private let accentColor: Color?
    private let actionTitle: String?
    private let action: (() -> Void)?
    private let content: Content

    /// Creates a detail card for content that should appear inside its own visual card.
    public init(
        title: String? = nil,
        accentColor: Color? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.accentColor = accentColor
        self.actionTitle = actionTitle
        self.action = action
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if title != nil || actionTitle != nil {
                HStack(alignment: .firstTextBaseline) {
                    if let title {
                        Text(title)
                            .font(.headline)
                    }

                    Spacer()

                    if let actionTitle, let action {
                        Button(actionTitle, action: action)
                            .font(.subheadline.weight(.semibold))
                    }
                }
            }

            content
        }
        .padding(16)
        .background(backgroundView)
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(borderColor, lineWidth: 1)
        )
    }
}

private extension SimpleDetailCard {
    @ViewBuilder
    var backgroundView: some View {
        if let accentColor {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [accentColor.opacity(0.28), accentColor.opacity(0.08)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        } else {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.secondary.opacity(0.10))
        }
    }

    var borderColor: Color {
        if let accentColor {
            return accentColor.opacity(0.25)
        }

        return Color.primary.opacity(0.08)
    }
}

#if DEBUG
#Preview {
    VStack(spacing: 12) {
        SimpleDetailCard(title: "Overview") {
            Text("Card content")
        }

        SimpleDetailCard(title: "Accent", accentColor: .orange) {
            Text("Accent card")
        }
    }
    .padding()
}
#endif
