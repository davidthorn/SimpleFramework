//
//  SimpleWorkoutDetailCardView.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import SwiftUI

/// A reusable card container for workout detail sections.
public struct SimpleWorkoutDetailCardView<Content: View>: View {
    private let title: String?
    private let accentColor: Color?
    private let actionTitle: String?
    private let action: (() -> Void)?
    private let content: Content

    /// Creates a workout detail card.
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

private extension SimpleWorkoutDetailCardView {
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
        SimpleWorkoutDetailCardView(title: "Overview") {
            Text("Card content")
        }

        SimpleWorkoutDetailCardView(title: "Accent", accentColor: .orange) {
            Text("Accent card")
        }
    }
    .padding()
}
#endif
