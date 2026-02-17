//
//  SimpleDestructiveConfirmationCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleDestructiveConfirmationCard: View {
    public let title: String
    public let message: String
    public let confirmTitle: String
    public let tint: Color
    public let isDisabled: Bool
    public let onCancel: () -> Void
    public let onConfirm: () -> Void

    public init(
        title: String,
        message: String,
        confirmTitle: String = "Delete",
        tint: Color = .red,
        isDisabled: Bool = false,
        onCancel: @escaping () -> Void,
        onConfirm: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirmTitle = confirmTitle
        self.tint = tint
        self.isDisabled = isDisabled
        self.onCancel = onCancel
        self.onConfirm = onConfirm
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill")
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
                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }

            HStack(spacing: 10) {
                SimpleActionButton(
                    title: "Cancel",
                    systemImage: "xmark",
                    tint: .gray,
                    style: .bordered,
                    isEnabled: isDisabled == false,
                    action: onCancel
                )

                SimpleActionButton(
                    title: confirmTitle,
                    systemImage: "trash.fill",
                    tint: tint,
                    style: .filled,
                    isEnabled: isDisabled == false,
                    action: onConfirm
                )
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.22), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        SimpleDestructiveConfirmationCard(
            title: "Delete this item?",
            message: "This action cannot be undone.",
            confirmTitle: "Delete Item",
            onCancel: {},
            onConfirm: {}
        )
        .padding()
        .background(Color.black.opacity(0.05))
    }
#endif
