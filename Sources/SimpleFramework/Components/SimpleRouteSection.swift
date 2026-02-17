//
//  SimpleRouteSection.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleRouteSection<Content: View>: View {
    public let title: String
    public let content: Content

    public init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                content
            }
        }
    }
}

#if DEBUG
    #Preview {
        SimpleRouteSection(title: "Preferences") {
            SimpleRouteRow(
                title: "Units",
                subtitle: "Choose ml or oz",
                systemImage: "ruler",
                tint: .blue
            )
        }
        .padding()
    }
#endif
