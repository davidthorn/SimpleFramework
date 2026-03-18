//
//  SimpleRouteGroup.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

/// A titled group of navigation routes.
///
/// Use `SimpleRouteGroup` to organize multiple `SimpleRouteRow` items under a shared heading. Unlike
/// `SimpleContentSection`, this type is specifically for grouped navigation destinations. Unlike
/// `SimpleDetailCard`, it does not add card styling of its own.
public struct SimpleRouteGroup<Content: View>: View {
    /// The title displayed above the grouped routes.
    public let title: String

    /// The route-row content contained in the group.
    public let content: Content

    /// Creates a new route group for navigation rows.
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

/// Backward-compatible alias for the previous route-group name.
@available(*, deprecated, renamed: "SimpleRouteGroup")
public typealias SimpleRouteSection<Content: View> = SimpleRouteGroup<Content>

#if DEBUG
    #Preview {
        SimpleRouteGroup(title: "Preferences") {
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
