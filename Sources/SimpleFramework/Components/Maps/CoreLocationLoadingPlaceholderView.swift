//
//  CoreLocationLoadingPlaceholderView.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.02.2026.
//

import SwiftUI

/// Placeholder shown while route coordinates are not yet available.
public struct CoreLocationLoadingPlaceholderView: View {
    /// The accent color used by the placeholder icon.
    public let accentTint: Color

    /// Creates a map placeholder view.
    public init(accentTint: Color = .accentColor) {
        self.accentTint = accentTint
    }

    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(backgroundGradient)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(borderGradient, lineWidth: 1)

            VStack(spacing: 12) {
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(accentTint)

                Text("Retrieving Current Location")
                    .font(.headline)

                ProgressView()
                    .controlSize(.regular)
            }
            .padding()
        }
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color.secondary.opacity(0.10), Color.secondary.opacity(0.04)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [Color.white.opacity(0.55), Color.white.opacity(0.20)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

#if DEBUG
#Preview {
    CoreLocationLoadingPlaceholderView()
        .frame(height: 320)
        .padding()
}
#endif
