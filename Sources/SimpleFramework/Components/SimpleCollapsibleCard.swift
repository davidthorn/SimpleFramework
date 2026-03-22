//
//  SimpleCollapsibleCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 22.03.2026.
//

import SwiftUI

public struct SimpleCollapsibleCard<Content: View>: View {
    public let title: String
    public let summary: String
    @Binding public var isExpanded: Bool
    public let tint: Color
    private let content: Content

    public init(
        title: String,
        summary: String,
        isExpanded: Binding<Bool>,
        tint: Color,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.summary = summary
        self._isExpanded = isExpanded
        self.tint = tint
        self.content = content()
    }

    public var body: some View {
        SimpleDetailCard(accentColor: tint) {
            VStack(alignment: .leading, spacing: 12) {
                Button {
                    isExpanded.toggle()
                } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(title)
                                .font(.headline)
                                .foregroundStyle(.primary)

                            Text(summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .font(.title3)
                            .foregroundStyle(tint)
                    }
                }
                .buttonStyle(.plain)

                if isExpanded {
                    content
                }
            }
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var isExpanded: Bool = false

        SimpleCollapsibleCard(
            title: "Type Wet",
            summary: "Mostly urine only.",
            isExpanded: $isExpanded,
            tint: .blue
        ) {
            Text("Expanded content")
        }
        .padding()
    }
#endif
