//
//  SimpleFilterMenu.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import SwiftUI

/// A reusable toolbar menu for grouped filter selections.
///
/// Use `SimpleFilterMenu` for secondary or less-frequent list filters that fit better in the toolbar than in
/// the main page content. Combine it with `SimpleSearchFilterCard` when a screen needs both primary in-page
/// filters and secondary menu-based filters.
public struct SimpleFilterMenu: View {
    private let title: String
    private let systemImage: String
    private let sections: [SimpleFilterMenuSection]

    /// Creates a filter menu.
    ///
    /// - Parameters:
    ///   - title: The toolbar label shown for the menu.
    ///   - systemImage: The SF Symbol displayed beside the title.
    ///   - sections: The grouped filter sections shown inside the menu.
    public init(
        title: String,
        systemImage: String,
        sections: [SimpleFilterMenuSection]
    ) {
        self.title = title
        self.systemImage = systemImage
        self.sections = sections
    }

    public var body: some View {
        Menu {
            ForEach(sections) { section in
                Section(section.title) {
                    ForEach(section.options) { option in
                        Button(action: option.action) {
                            if option.isSelected {
                                Label(option.title, systemImage: "checkmark")
                            } else {
                                Text(option.title)
                            }
                        }
                    }
                }
            }
        } label: {
            Label(title, systemImage: systemImage)
        }
    }
}

#if DEBUG
    #Preview {
        NavigationStack {
            Text("Open the toolbar menu")
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        SimpleFilterMenu(
                            title: "Filters",
                            systemImage: "line.3.horizontal.decrease.circle",
                            sections: [
                                SimpleFilterMenuSection(
                                    id: "time",
                                    title: "Time Range",
                                    options: [
                                        SimpleFilterMenuOption(
                                            id: "all",
                                            title: "All Time",
                                            isSelected: true,
                                            action: {}
                                        ),
                                        SimpleFilterMenuOption(
                                            id: "week",
                                            title: "Last 7 Days",
                                            isSelected: false,
                                            action: {}
                                        )
                                    ]
                                ),
                                SimpleFilterMenuSection(
                                    id: "status",
                                    title: "Status",
                                    options: [
                                        SimpleFilterMenuOption(
                                            id: "open",
                                            title: "Open",
                                            isSelected: false,
                                            action: {}
                                        ),
                                        SimpleFilterMenuOption(
                                            id: "done",
                                            title: "Completed",
                                            isSelected: true,
                                            action: {}
                                        )
                                    ]
                                )
                            ]
                        )
                    }
                }
        }
    }
#endif
