//
//  SimpleFormActionButtons.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleFormActionButtons: View {
    public let showSave: Bool
    public let showReset: Bool
    public let showDelete: Bool

    public let saveTitle: String
    public let resetTitle: String
    public let deleteTitle: String

    public let onSave: () -> Void
    public let onReset: () -> Void
    public let onDelete: () -> Void

    public init(
        showSave: Bool,
        showReset: Bool,
        showDelete: Bool,
        saveTitle: String = "Save",
        resetTitle: String = "Reset",
        deleteTitle: String = "Delete",
        onSave: @escaping () -> Void,
        onReset: @escaping () -> Void,
        onDelete: @escaping () -> Void
    ) {
        self.showSave = showSave
        self.showReset = showReset
        self.showDelete = showDelete
        self.saveTitle = saveTitle
        self.resetTitle = resetTitle
        self.deleteTitle = deleteTitle
        self.onSave = onSave
        self.onReset = onReset
        self.onDelete = onDelete
    }

    public var body: some View {
        VStack(spacing: 10) {
            if showSave {
                SimpleActionButton(
                    title: saveTitle,
                    systemImage: "checkmark.circle.fill",
                    tint: .accentColor,
                    style: .filled,
                    action: onSave
                )
            }

            if showReset {
                SimpleActionButton(
                    title: resetTitle,
                    systemImage: "arrow.uturn.backward.circle.fill",
                    tint: .orange,
                    style: .bordered,
                    action: onReset
                )
            }

            if showDelete {
                SimpleActionButton(
                    title: deleteTitle,
                    systemImage: "trash.fill",
                    tint: .red,
                    style: .filled,
                    action: onDelete
                )
            }
        }
    }
}

#if DEBUG
    #Preview {
        SimpleFormActionButtons(
            showSave: true,
            showReset: true,
            showDelete: true,
            saveTitle: "Save Goal",
            deleteTitle: "Delete Goal",
            onSave: {},
            onReset: {},
            onDelete: {}
        )
        .padding()
    }
#endif
