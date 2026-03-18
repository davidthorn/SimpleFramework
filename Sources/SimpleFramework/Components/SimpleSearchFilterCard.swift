//
//  SimpleSearchFilterCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import SwiftUI

/// A reusable filter surface with search input and a primary segmented selection.
public struct SimpleSearchFilterCard: View {
    private let searchText: Binding<String>
    private let searchTitle: String
    private let searchPlaceholder: String
    private let searchHelperText: String?
    private let searchTint: Color
    private let selectedFilterValue: Binding<String>
    private let filterTitle: String
    private let filterOptions: [SimpleSegmentedChoiceOption]

    /// Creates a new search and segmented-filter card.
    public init(
        searchText: Binding<String>,
        searchTitle: String,
        searchPlaceholder: String,
        searchHelperText: String? = nil,
        searchTint: Color = .blue,
        selectedFilterValue: Binding<String>,
        filterTitle: String,
        filterOptions: [SimpleSegmentedChoiceOption]
    ) {
        self.searchText = searchText
        self.searchTitle = searchTitle
        self.searchPlaceholder = searchPlaceholder
        self.searchHelperText = searchHelperText
        self.searchTint = searchTint
        self.selectedFilterValue = selectedFilterValue
        self.filterTitle = filterTitle
        self.filterOptions = filterOptions
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SimpleLabeledTextFieldCard(
                text: searchText,
                title: searchTitle,
                placeholder: searchPlaceholder,
                helperText: searchHelperText,
                tint: searchTint,
                isEnabled: true,
                keyboardKind: .default
            )

            SimpleSegmentedChoiceCard(
                selectedValue: selectedFilterValue,
                title: filterTitle,
                options: filterOptions
            )
        }
    }
}

#if DEBUG
    #Preview {
        struct SimpleSearchFilterCardPreviewHost: View {
            @State private var searchText: String = ""
            @State private var selectedValue: String = "all"

            var body: some View {
                SimpleSearchFilterCard(
                    searchText: $searchText,
                    searchTitle: "Search",
                    searchPlaceholder: "Find an item",
                    selectedFilterValue: $selectedValue,
                    filterTitle: "Type",
                    filterOptions: [
                        SimpleSegmentedChoiceOption(title: "All", value: "all"),
                        SimpleSegmentedChoiceOption(title: "Open", value: "open"),
                        SimpleSegmentedChoiceOption(title: "Done", value: "done")
                    ]
                )
                .padding()
            }
        }

        return SimpleSearchFilterCardPreviewHost()
    }
#endif
