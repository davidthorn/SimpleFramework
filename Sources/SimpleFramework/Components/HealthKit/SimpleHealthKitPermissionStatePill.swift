//
//  SimpleHealthKitPermissionStatePill.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleHealthKitPermissionStatePill: View {
    public let title: String
    public let state: HealthKitAuthorizationState
    public let authorizedTint: Color
    public let deniedTint: Color
    public let pendingTint: Color
    public let unavailableTint: Color

    public init(
        title: String,
        state: HealthKitAuthorizationState,
        authorizedTint: Color = .green,
        deniedTint: Color = .red,
        pendingTint: Color = .orange,
        unavailableTint: Color = .secondary
    ) {
        self.title = title
        self.state = state
        self.authorizedTint = authorizedTint
        self.deniedTint = deniedTint
        self.pendingTint = pendingTint
        self.unavailableTint = unavailableTint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(state.displayText)
                .font(.caption.weight(.semibold))
                .foregroundStyle(tint(for: state))
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule(style: .continuous)
                        .fill(tint(for: state).opacity(0.14))
                )
        }
    }

    private func tint(for state: HealthKitAuthorizationState) -> Color {
        switch state {
        case .authorized:
            return authorizedTint
        case .denied:
            return deniedTint
        case .notDetermined:
            return pendingTint
        case .unavailable:
            return unavailableTint
        }
    }
}

#if DEBUG
    #Preview {
        HStack(spacing: 12) {
            SimpleHealthKitPermissionStatePill(title: "Read", state: .authorized)
            SimpleHealthKitPermissionStatePill(title: "Write", state: .denied)
        }
        .padding()
    }
#endif
