//
//  SimpleDateRangeSummaryCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleDateRangeSummaryCard: View {
    public let title: String
    public let startTitle: String
    public let endTitle: String
    public let startDate: Date
    public let endDate: Date
    public let tint: Color

    public init(
        title: String = "Selected Range",
        startTitle: String = "Start",
        endTitle: String = "End",
        startDate: Date,
        endDate: Date,
        tint: Color = .accentColor
    ) {
        self.title = title
        self.startTitle = startTitle
        self.endTitle = endTitle
        self.startDate = startDate
        self.endDate = endDate
        self.tint = tint
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            labeledRow(
                title: startTitle,
                value: startDate.formatted(date: .abbreviated, time: .omitted)
            )

            labeledRow(
                title: endTitle,
                value: endDate.formatted(date: .abbreviated, time: .omitted)
            )
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(tint.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func labeledRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.primary.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(tint.opacity(0.15), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        SimpleDateRangeSummaryCard(
            startDate: Date().addingTimeInterval(-86_400 * 7),
            endDate: Date(),
            tint: .orange
        )
        .padding()
    }
#endif
