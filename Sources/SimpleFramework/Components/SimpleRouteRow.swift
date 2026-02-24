//
//  SimpleRouteRow.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

/// A reusable route row card with icon, title, subtitle, and trailing chevron.
public struct SimpleRouteRow: View {
    public let title: String
    public let subtitle: String
    public let systemImage: String
    public let tint: Color
    public let isEnabled: Bool

    /// Creates a route row.
    public init(
        title: String,
        subtitle: String,
        systemImage: String,
        tint: Color = .accentColor,
        isEnabled: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.tint = tint
        self.isEnabled = isEnabled
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(isEnabled ? tint : .secondary)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill((isEnabled ? tint : .secondary).opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isEnabled ? .primary : .secondary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
        )
        .opacity(isEnabled ? 1 : 0.7)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue(subtitle)
        .accessibilityHint(isEnabled ? "Opens this route." : "Unavailable.")
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 12) {
            SimpleRouteRow(
                title: "Units",
                subtitle: "Choose ml or oz",
                systemImage: "ruler",
                tint: .blue
            )
            SimpleRouteRow(
                title: "Edit Latest Entry",
                subtitle: "Add data first to enable editing",
                systemImage: "pencil",
                tint: .orange,
                isEnabled: false
            )
        }
        .padding()
    }
#endif
