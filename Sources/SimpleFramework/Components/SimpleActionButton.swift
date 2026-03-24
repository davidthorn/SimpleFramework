//
//  SimpleActionButton.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI
import UIKit

public struct SimpleActionButton: View {
    public enum Style: Sendable {
        case filled
        case bordered
    }

    public let title: String
    public let systemImage: String
    public let tint: Color
    public let style: Style
    public let isEnabled: Bool
    public let action: () -> Void

    public init(
        title: String,
        systemImage: String,
        tint: Color = .accentColor,
        style: Style = .filled,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.style = style
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(style == .filled ? Color.white : tint)
                .background(backgroundShape)
        }
        .buttonStyle(.plain)
        .disabled(isEnabled == false)
        .opacity(isEnabled ? 1 : 0.5)
    }

    private var backgroundShape: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(style == .filled ? tint : borderedBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(tint.opacity(style == .filled ? 0 : 0.35), lineWidth: 1)
            )
    }

    private var borderedBackgroundColor: Color {
        Color(
            uiColor: UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return UIColor(red: 0.16, green: 0.16, blue: 0.17, alpha: 0.96)
                default:
                    return UIColor(white: 1, alpha: 0.82)
                }
            }
        )
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 12) {
            SimpleActionButton(
                title: "Save",
                systemImage: "checkmark.circle.fill",
                style: .filled
            ) {}

            SimpleActionButton(
                title: "Reset",
                systemImage: "arrow.uturn.backward.circle.fill",
                tint: .orange,
                style: .bordered
            ) {}
        }
        .padding()
    }
#endif
