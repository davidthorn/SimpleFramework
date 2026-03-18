//
//  SimpleFilterMenu.swift
//  SimpleFramework
//
//  Created by David Thorn on 18.03.2026.
//

import SwiftUI

/// A reusable toolbar menu for grouped filter selections.
public struct SimpleFilterMenu: View {
    private let title: String
    private let systemImage: String
    private let sections: [SimpleFilterMenuSection]

    /// Creates a filter menu.
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
        .padding()
    }
#endif
