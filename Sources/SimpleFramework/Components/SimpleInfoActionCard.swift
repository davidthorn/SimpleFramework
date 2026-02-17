//
//  SimpleInfoActionCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleInfoActionCard: View {
    public let title: String
    public let subtitle: String
    public let systemImage: String
    public let tint: Color
    public let actionTitle: String?
    public let actionSystemImage: String?
    public let actionTint: Color?
    public let isActionEnabled: Bool
    public let action: (() -> Void)?

    public init(
        title: String,
        subtitle: String,
        systemImage: String,
        tint: Color = .accentColor,
        actionTitle: String? = nil,
        actionSystemImage: String? = nil,
        actionTint: Color? = nil,
        isActionEnabled: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.tint = tint
        self.actionTitle = actionTitle
        self.actionSystemImage = actionSystemImage
        self.actionTint = actionTint
        self.isActionEnabled = isActionEnabled
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: systemImage)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(tint)
                    .padding(9)
                    .background(
                        Circle()
                            .fill(tint.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            if
                let actionTitle,
                let actionSystemImage,
                let actionTint,
                let action
            {
                SimpleActionButton(
                    title: actionTitle,
                    systemImage: actionSystemImage,
                    tint: actionTint,
                    style: .filled,
                    isEnabled: isActionEnabled,
                    action: action
                )
            }
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
            SimpleInfoActionCard(
                title: "Permission Denied",
                subtitle: "Open Settings and enable notifications for this app.",
                systemImage: "exclamationmark.triangle.fill",
                tint: .red,
                actionTitle: "Open Settings",
                actionSystemImage: "gearshape.fill",
                actionTint: .red,
                action: {}
            )

            SimpleInfoActionCard(
                title: "Permission Approved",
                subtitle: "Notifications are enabled.",
                systemImage: "checkmark.seal.fill",
                tint: .green
            )
        }
        .padding()
    }
#endif
