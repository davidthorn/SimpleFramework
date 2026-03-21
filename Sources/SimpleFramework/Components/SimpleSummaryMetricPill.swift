//
//  SimpleSummaryMetricPill.swift
//  SimpleFramework
//
//  Created by David Thorn on 21.03.2026.
//

import SwiftUI

public struct SimpleSummaryMetricPill: View {
    public let title: String
    public let value: String
    public let systemImage: String
    public let tint: Color

    public init(
        title: String,
        value: String,
        systemImage: String,
        tint: Color
    ) {
        self.title = title
        self.value = value
        self.systemImage = systemImage
        self.tint = tint
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)
                .frame(width: 28, height: 28)
                .background(
                    tint.opacity(0.12),
                    in: RoundedRectangle(cornerRadius: 10, style: .continuous)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .monospacedDigit()
            }
            .frame(maxHeight: .infinity, alignment: .topLeading)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.70))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(tint.opacity(0.18), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview("Metric Pill Variants") {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                SimpleSummaryMetricPill(
                    title: "Total",
                    value: "8m",
                    systemImage: "timer",
                    tint: .pink
                )

                SimpleSummaryMetricPill(
                    title: "Average",
                    value: "12m",
                    systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    tint: .orange
                )
            }

            HStack(spacing: 10) {
                SimpleSummaryMetricPill(
                    title: "Total",
                    value: "3 min, 9 secs",
                    systemImage: "timer",
                    tint: .pink
                )

                SimpleSummaryMetricPill(
                    title: "Average",
                    value: "24 secs",
                    systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    tint: .orange
                )
            }

            HStack(spacing: 10) {
                SimpleSummaryMetricPill(
                    title: "Total",
                    value: "12 hr, 42 min",
                    systemImage: "timer",
                    tint: .pink
                )

                SimpleSummaryMetricPill(
                    title: "Average",
                    value: "1 hr, 47 min",
                    systemImage: "clock.arrow.trianglehead.counterclockwise.rotate.90",
                    tint: .orange
                )
            }
        }
        .padding()
    }
#endif
