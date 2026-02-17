//
//  SimpleSegmentedChoiceCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleSegmentedChoiceCard: View {
    @Binding public var selectedValue: String

    public let title: String
    public let options: [SimpleSegmentedChoiceOption]

    public init(
        selectedValue: Binding<String>,
        title: String,
        options: [SimpleSegmentedChoiceOption]
    ) {
        _selectedValue = selectedValue
        self.title = title
        self.options = options
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            Picker(title, selection: $selectedValue) {
                ForEach(options) { option in
                    Text(option.title).tag(option.value)
                }
            }
            .pickerStyle(.segmented)
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
    private struct SimpleSegmentedChoiceCardPreviewHost: View {
        @State private var selected: String = "kg"

        var body: some View {
            SimpleSegmentedChoiceCard(
                selectedValue: $selected,
                title: "Unit",
                options: [
                    SimpleSegmentedChoiceOption(title: "kg", value: "kg"),
                    SimpleSegmentedChoiceOption(title: "lb", value: "lb")
                ]
            )
            .padding()
        }
    }

    #Preview {
        SimpleSegmentedChoiceCardPreviewHost()
    }
#endif
