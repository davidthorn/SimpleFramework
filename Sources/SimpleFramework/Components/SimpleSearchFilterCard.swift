//
//  SimpleSearchFilterCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import SwiftUI

/// A reusable filter surface with search input and a primary segmented selection.
///
/// Use `SimpleSearchFilterCard` at the top of list-style screens when users need to combine free-text search
/// with one primary segmented filter, such as type, status, or category. Secondary filters that do not fit
/// comfortably in the page content can be paired with `SimpleFilterMenu` in the toolbar.
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
    ///
    /// - Parameters:
    ///   - searchText: The bound free-text query.
    ///   - searchTitle: The title shown above the search field.
    ///   - searchPlaceholder: Placeholder text shown when the search field is empty.
    ///   - searchHelperText: Optional supporting text shown below the search field.
    ///   - searchTint: The accent tint used by the search field.
    ///   - selectedFilterValue: The bound selected segmented-filter value.
    ///   - filterTitle: The title shown above the segmented filter.
    ///   - filterOptions: The available segmented-filter options.
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
                    searchPlaceholder: "Find a workout",
                    searchHelperText: "Search works together with the selected filter.",
                    selectedFilterValue: $selectedValue,
                    filterTitle: "Category",
                    filterOptions: [
                        SimpleSegmentedChoiceOption(title: "All", value: "all"),
                        SimpleSegmentedChoiceOption(title: "Run", value: "run"),
                        SimpleSegmentedChoiceOption(title: "Ride", value: "ride")
                    ]
                )
                .padding()
            }
        }

        return SimpleSearchFilterCardPreviewHost()
    }
#endif
