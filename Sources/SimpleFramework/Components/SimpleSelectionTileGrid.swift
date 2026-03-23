//
//  SimpleSelectionTileGrid.swift
//  SimpleFramework
//
//  Created by David Thorn on 23.03.2026.
//

import SwiftUI

public struct SimpleSelectionTileGrid<ID: Hashable>: View {
    public let options: [SimpleSelectionTileOption<ID>]
    public let selectedID: ID?
    public let columns: [GridItem]
    public let spacing: CGFloat
    public let onSelect: (ID) -> Void

    public init(
        options: [SimpleSelectionTileOption<ID>],
        selectedID: ID?,
        columns: [GridItem],
        spacing: CGFloat = 12,
        onSelect: @escaping (ID) -> Void
    ) {
        self.options = options
        self.selectedID = selectedID
        self.columns = columns
        self.spacing = spacing
        self.onSelect = onSelect
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: spacing) {
            ForEach(options) { option in
                Button {
                    onSelect(option.id)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(option.title)
                            .font(.subheadline.weight(.semibold))

                        if let subtitle = option.subtitle {
                            Text(subtitle)
                                .font(.caption)
                                .foregroundStyle(
                                    isSelected(option.id)
                                        ? Color.white.opacity(0.9)
                                        : Color.secondary
                                )
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .foregroundStyle(
                        isSelected(option.id) ? Color.white : Color.primary
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                isSelected(option.id)
                                    ? option.tint
                                    : option.tint.opacity(0.12)
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isSelected(option.id)
                                    ? option.tint
                                    : option.tint.opacity(0.25),
                                lineWidth: 1
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func isSelected(_ optionID: ID) -> Bool {
        selectedID == optionID
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var selectedID: String? = "wet"

        SimpleSelectionTileGrid(
            options: [
                SimpleSelectionTileOption(id: "wet", title: "Wet", subtitle: "Mostly wet", tint: .blue),
                SimpleSelectionTileOption(id: "dirty", title: "Dirty", subtitle: "Stool present", tint: .brown),
                SimpleSelectionTileOption(id: "both", title: "Both", subtitle: "Wet and dirty", tint: .orange),
                SimpleSelectionTileOption(id: "dry", title: "Dry", subtitle: "Nothing much", tint: .green)
            ],
            selectedID: selectedID,
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ]
        ) { selectedID = $0 }
        .padding()
    }
#endif

