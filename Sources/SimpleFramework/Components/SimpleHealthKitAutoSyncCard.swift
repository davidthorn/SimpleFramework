//
//  SimpleHealthKitAutoSyncCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleHealthKitAutoSyncCard: View {
    @Binding public var isAutoSyncEnabled: Bool
    public let isHealthKitAvailable: Bool
    public let tint: Color

    public init(
        isAutoSyncEnabled: Binding<Bool>,
        isHealthKitAvailable: Bool,
        tint: Color = .green
    ) {
        _isAutoSyncEnabled = isAutoSyncEnabled
        self.isHealthKitAvailable = isHealthKitAvailable
        self.tint = tint
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(tint.opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Automatic Sync")
                    .font(.subheadline.weight(.semibold))
                Text("When enabled, newly created logs are also saved to HealthKit.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: $isAutoSyncEnabled)
                .labelsHidden()
                .disabled(isHealthKitAvailable == false)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        SimpleHealthKitAutoSyncCard(
            isAutoSyncEnabled: .constant(true),
            isHealthKitAvailable: true
        )
        .padding()
    }
#endif
