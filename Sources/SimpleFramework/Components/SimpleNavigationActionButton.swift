//
//  SimpleNavigationActionButton.swift
//  SimpleFramework
//
//  Created by David Thorn on 23.03.2026.
//

import SwiftUI

public struct SimpleNavigationActionButton<Route: Hashable>: View {
    public let route: Route
    public let title: String
    public let systemImage: String
    public let tint: Color
    public let style: SimpleActionButton.Style
    public let isEnabled: Bool

    public init(
        route: Route,
        title: String,
        systemImage: String,
        tint: Color = .accentColor,
        style: SimpleActionButton.Style = .filled,
        isEnabled: Bool = true
    ) {
        self.route = route
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.style = style
        self.isEnabled = isEnabled
    }

    public var body: some View {
        NavigationLink(value: route) {
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
            .fill(style == .filled ? tint : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(tint.opacity(style == .filled ? 0 : 0.35), lineWidth: 1)
            )
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            SimpleNavigationActionButton(
                route: 1,
                title: "Edit",
                systemImage: "pencil.circle.fill",
                tint: .orange,
                style: .filled
            )
            .padding()
            .navigationDestination(for: Int.self) { _ in
                Text("Destination")
            }
        }
    }
#endif
