//
//  SimpleHealthKitPermissionsCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleHealthKitPermissionsCard: View {
    public let permissionState: HealthKitPermissionState
    public let statusSummaryText: String
    public let isHealthKitAvailable: Bool
    public let accentTint: Color
    public let onRequestAccess: () -> Void
    public let onOpenSettings: () -> Void

    public init(
        permissionState: HealthKitPermissionState,
        statusSummaryText: String,
        isHealthKitAvailable: Bool,
        accentTint: Color = .orange,
        onRequestAccess: @escaping () -> Void,
        onOpenSettings: @escaping () -> Void
    ) {
        self.permissionState = permissionState
        self.statusSummaryText = statusSummaryText
        self.isHealthKitAvailable = isHealthKitAvailable
        self.accentTint = accentTint
        self.onRequestAccess = onRequestAccess
        self.onOpenSettings = onOpenSettings
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "lock.shield")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(accentTint)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(accentTint.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("Permissions")
                        .font(.subheadline.weight(.semibold))

                    Text(statusSummaryText)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()
            }

            HStack(spacing: 10) {
                SimpleHealthKitPermissionStatePill(
                    title: "Read",
                    state: permissionState.read
                )
                SimpleHealthKitPermissionStatePill(
                    title: "Write",
                    state: permissionState.write
                )
                Spacer()
            }

            if isHealthKitAvailable {
                HStack(spacing: 10) {
                    Button("Request Access") {
                        onRequestAccess()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Open Settings") {
                        onOpenSettings()
                    }
                    .buttonStyle(.bordered)
                }
            }
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
        SimpleHealthKitPermissionsCard(
            permissionState: HealthKitPermissionState(read: .authorized, write: .denied),
            statusSummaryText: "Read is authorized, write is denied.",
            isHealthKitAvailable: true,
            onRequestAccess: {},
            onOpenSettings: {}
        )
        .padding()
    }
#endif
