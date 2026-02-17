//
//  SimpleDateTimeInputCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleDateTimeInputCard: View {
    @Binding public var date: Date
    @State private var isEditorPresented: Bool

    public let title: String
    public let subtitle: String
    public let icon: String
    public let accent: Color

    public init(
        date: Binding<Date>,
        title: String = "Date & Time",
        subtitle: String = "Adjust when this entry was captured.",
        icon: String = "calendar.badge.clock",
        accent: Color = .accentColor
    ) {
        _date = date
        _isEditorPresented = State(initialValue: false)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accent = accent
    }

    public var body: some View {
        Button {
            isEditorPresented = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(accent)
                    .frame(width: 28, height: 28)
                    .background(
                        Circle()
                            .fill(accent.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(date.formatted(date: .abbreviated, time: .omitted))
                        .font(.subheadline.weight(.semibold))
                    Text(date.formatted(date: .omitted, time: .shortened))
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("Edit")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(accent.opacity(0.14))
                    )
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.white.opacity(0.75))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $isEditorPresented) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 14) {
                    header

                    VStack(alignment: .leading, spacing: 10) {
                        titleLabel("Date")
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                    }
                    .padding(14)
                    .background(cardBackground)

                    VStack(alignment: .leading, spacing: 10) {
                        titleLabel("Time")
                        DatePicker("Time", selection: $date, displayedComponents: .hourAndMinute)
#if os(macOS)
                            .datePickerStyle(.field)
#else
                            .datePickerStyle(.wheel)
#endif
                            .labelsHidden()
                            .frame(maxWidth: .infinity)
                            .frame(height: 150)
                            .clipped()
                    }
                    .padding(14)
                    .background(cardBackground)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .toolbar {
                    ToolbarItem(placement: doneToolbarPlacement) {
                        Button("Done") {
                            isEditorPresented = false
                        }
                        .font(.subheadline.weight(.semibold))
                    }
                }
            }
            .tint(accent)
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.secondary.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(accent)
                .padding(9)
                .background(
                    Circle()
                        .fill(accent.opacity(0.14))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.secondary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(accent.opacity(0.2), lineWidth: 1)
                )
        )
    }

    private func titleLabel(_ value: String) -> some View {
        Text(value.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(.secondary)
    }

    private var doneToolbarPlacement: ToolbarItemPlacement {
#if os(macOS)
        .automatic
#else
        .topBarTrailing
#endif
    }
}

#if DEBUG
    private struct SimpleDateTimeInputCardPreviewHost: View {
        @State private var date: Date = .now

        var body: some View {
            SimpleDateTimeInputCard(date: $date)
                .padding()
        }
    }

    #Preview {
        SimpleDateTimeInputCardPreviewHost()
    }
#endif
