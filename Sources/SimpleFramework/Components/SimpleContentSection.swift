//
//  SimpleContentSection.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import SwiftUI

/// A lightweight container that keeps related content visually grouped.
public struct SimpleContentSection<Content: View>: View {
    /// The section title displayed above the content block.
    public let title: String

    /// Optional leading copy shown beneath the title.
    public let header: String?

    /// Optional supporting copy shown beneath the content block.
    public let footer: String?

    /// The section content.
    public let content: Content

    /// Creates a new content section.
    public init(
        title: String,
        header: String? = nil,
        footer: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.header = header
        self.footer = footer
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                SimpleSectionTitleLabel(title: title, tint: .secondary)

                if let header, header.isEmpty == false {
                    Text(header)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                content
            }

            if let footer, footer.isEmpty == false {
                Text(footer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#if DEBUG
    #Preview {
        SimpleContentSection(
            title: "Details",
            header: "Keep the setup focused and readable.",
            footer: "Footer copy can reinforce the section purpose."
        ) {
            SimpleToastCard(
                message: "Preview content",
                systemImage: "checkmark.circle.fill",
                tint: .green
            )
        }
        .padding()
    }
#endif
