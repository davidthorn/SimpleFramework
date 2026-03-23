//
//  SimpleSelectionTileCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 23.03.2026.
//

import SwiftUI

public struct SimpleSelectionTileCard<ID: Hashable>: View {
    public let title: String
    public let subtitle: String
    public let accentColor: Color
    public let options: [SimpleSelectionTileOption<ID>]
    public let selectedID: ID?
    public let columns: [GridItem]
    public let spacing: CGFloat
    public let onSelect: (ID) -> Void

    public init(
        title: String,
        subtitle: String,
        accentColor: Color = .accentColor,
        options: [SimpleSelectionTileOption<ID>],
        selectedID: ID?,
        columns: [GridItem],
        spacing: CGFloat = 12,
        onSelect: @escaping (ID) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.accentColor = accentColor
        self.options = options
        self.selectedID = selectedID
        self.columns = columns
        self.spacing = spacing
        self.onSelect = onSelect
    }

    public var body: some View {
        SimpleDetailCard(accentColor: accentColor) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.headline)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                SimpleSelectionTileGrid(
                    options: options,
                    selectedID: selectedID,
                    columns: columns,
                    spacing: spacing,
                    onSelect: onSelect
                )
            }
        }
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var selectedID: String? = "3"

        SimpleSelectionTileCard(
            title: "Size",
            subtitle: "Choose the size directly.",
            accentColor: .orange,
            options: [
                SimpleSelectionTileOption(id: "0", title: "0", tint: .orange),
                SimpleSelectionTileOption(id: "1", title: "1", tint: .orange),
                SimpleSelectionTileOption(id: "2", title: "2", tint: .orange),
                SimpleSelectionTileOption(id: "3", title: "3", tint: .orange)
            ],
            selectedID: selectedID,
            columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ]
        ) { selectedID = $0 }
        .padding()
    }
#endif
