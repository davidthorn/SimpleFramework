//
//  SimpleToggleFeatureCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 21.03.2026.
//

import SwiftUI

public struct SimpleToggleFeatureCard: View {
    @Binding public var isOn: Bool

    public let title: String
    public let systemImage: String
    public let tint: Color

    public init(
        isOn: Binding<Bool>,
        title: String,
        systemImage: String,
        tint: Color = .accentColor
    ) {
        self._isOn = isOn
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isOn ? filledSystemImage : systemImage)
                .font(.headline.weight(.semibold))
                .foregroundStyle(tint)
                .padding(10)
                .background(
                    Circle()
                        .fill(tint.opacity(0.14))
                )

            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(tint)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(tint.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(tint.opacity(0.14), lineWidth: 1)
                )
        )
    }

    private var filledSystemImage: String {
        if systemImage == "bell" {
            return "bell.fill"
        }

        return systemImage
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var isEnabled: Bool = true

        SimpleToggleFeatureCard(
            isOn: $isEnabled,
            title: "Enable",
            systemImage: "bell",
            tint: .orange
        )
        .padding()
    }
#endif
