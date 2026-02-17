//
//  SimpleSelectableCardRow.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

/// A reusable card row with leading icon, text content, and selectable trailing control.
public struct SimpleSelectableCardRow: View {
    /// Primary title text.
    public let title: String
    /// Secondary subtitle text.
    public let subtitle: String
    /// SF Symbol name for the leading icon.
    public let systemImage: String
    /// Accent color used for the leading icon treatment.
    public let tint: Color
    /// Selection state shown on the trailing control.
    public let isSelected: Bool
    /// Callback when selection control is tapped.
    public let onToggleSelection: () -> Void

    /// Creates a selectable row card.
    public init(
        title: String,
        subtitle: String,
        systemImage: String,
        tint: Color = .accentColor,
        isSelected: Bool,
        onToggleSelection: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.tint = tint
        self.isSelected = isSelected
        self.onToggleSelection = onToggleSelection
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.body.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onToggleSelection) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? tint : .secondary)
            }
            .buttonStyle(.plain)
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
    }
}

#if DEBUG
    #Preview {
        SimpleSelectableCardRow(
            title: "Milk",
            subtitle: "$2.50",
            systemImage: "cart.fill.badge.plus",
            tint: .green,
            isSelected: false,
            onToggleSelection: {}
        )
        .padding()
    }
#endif
