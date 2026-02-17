//
//  SimpleToggleCardRow.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleToggleCardRow: View {
    @Binding public var isOn: Bool

    public let title: String
    public let message: String
    public let systemImage: String
    public let tint: Color
    public let isEnabled: Bool

    public init(
        isOn: Binding<Bool>,
        title: String,
        message: String,
        systemImage: String,
        tint: Color = .accentColor,
        isEnabled: Bool = true
    ) {
        _isOn = isOn
        self.title = title
        self.message = message
        self.systemImage = systemImage
        self.tint = tint
        self.isEnabled = isEnabled
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .disabled(isEnabled == false)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.black.opacity(0.05), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    private struct SimpleToggleCardRowPreviewHost: View {
        @State private var isOn: Bool = true

        var body: some View {
            SimpleToggleCardRow(
                isOn: $isOn,
                title: "Automatic Sync",
                message: "Keep records synced after each save.",
                systemImage: "arrow.triangle.2.circlepath.circle.fill",
                tint: .green,
                isEnabled: true
            )
            .padding()
        }
    }

    #Preview {
        SimpleToggleCardRowPreviewHost()
    }
#endif
