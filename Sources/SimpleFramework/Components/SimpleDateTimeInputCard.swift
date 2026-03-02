//
//  SimpleDateTimeInputCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleDateTimeInputCard: View {
    public enum EditorPresentationStyle: Sendable {
        case sheet
        case inline
    }

    @Binding public var date: Date
    @Binding public var isActive: Bool
    @State private var isEditorPresented: Bool
    @State private var hasInlineBeenHiddenToSheetMode: Bool

    public let title: String
    public let subtitle: String
    public let icon: String
    public let accent: Color
    public let presentationStyle: EditorPresentationStyle
    public let showsToggle: Bool

    public init(
        date: Binding<Date>,
        title: String = "Date & Time",
        subtitle: String = "Adjust when this entry was captured.",
        icon: String = "calendar.badge.clock",
        accent: Color = .accentColor,
        presentationStyle: EditorPresentationStyle = .sheet
    ) {
        _date = date
        _isActive = .constant(true)
        _isEditorPresented = State(initialValue: presentationStyle == .inline)
        _hasInlineBeenHiddenToSheetMode = State(initialValue: false)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accent = accent
        self.presentationStyle = presentationStyle
        self.showsToggle = false
    }

    public init(
        isActive: Binding<Bool>,
        date: Binding<Date>,
        title: String = "Date & Time",
        subtitle: String = "Adjust when this entry was captured.",
        icon: String = "calendar.badge.clock",
        accent: Color = .accentColor,
        presentationStyle: EditorPresentationStyle = .sheet
    ) {
        _date = date
        _isActive = isActive
        _isEditorPresented = State(initialValue: presentationStyle == .inline && isActive.wrappedValue)
        _hasInlineBeenHiddenToSheetMode = State(initialValue: false)
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.accent = accent
        self.presentationStyle = presentationStyle
        self.showsToggle = true
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isActive, activePresentationStyle == .sheet {
                Button {
                    isEditorPresented = true
                } label: {
                    headerCard
                }
                .buttonStyle(.plain)
            } else {
                headerCard
            }
           
            if isActive, activePresentationStyle == .inline, isEditorPresented {
                editorContent
                    .padding(12)
                    .background(cardBackground)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .sheet(isPresented: isSheetPresentedBinding) {
            sheetEditor
        }
        .onChange(of: isActive) { _, newValue in
            if newValue {
                isEditorPresented = presentationStyle == .inline
            } else {
                isEditorPresented = false
                hasInlineBeenHiddenToSheetMode = false
            }
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

    private var editorContent: some View {
        VStack(alignment: .leading, spacing: 14) {
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
        }
    }

    private var sheetEditor: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                header(showHideButton: false, showsToggleControl: false)
                editorContent
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

    private var editButtonTitle: String {
        return "Edit"
    }

    private var isSheetPresentedBinding: Binding<Bool> {
        Binding(
            get: {
                isActive && activePresentationStyle == .sheet && isEditorPresented
            },
            set: { isPresented in
                isEditorPresented = isPresented
            }
        )
    }

    private var activePresentationStyle: EditorPresentationStyle {
        hasInlineBeenHiddenToSheetMode ? .sheet : presentationStyle
    }

    private var headerCard: some View {
        header(
            showHideButton: isActive && activePresentationStyle == .inline && isEditorPresented,
            showsToggleControl: showsToggle
        )
    }

    private func header(showHideButton: Bool, showsToggleControl: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: icon)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(accent)
                    .padding(9)
                    .background(
                        Circle()
                            .fill(accent.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text(subtitle)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                if showHideButton {
                    Button("Done") {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isEditorPresented = false
                        }
                        hasInlineBeenHiddenToSheetMode = true
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(accent)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(
                        Capsule(style: .continuous)
                            .fill(accent.opacity(0.14))
                    )
                    .buttonStyle(.plain)
                } else if showsToggleControl {
                    Toggle("", isOn: $isActive)
                        .labelsHidden()
                }
            }

            if isActive {
                HStack(alignment: .center, spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(date.formatted(date: .abbreviated, time: .omitted))
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                        Text(date.formatted(date: .omitted, time: .shortened))
                            .font(.caption.weight(.medium))
                            .foregroundStyle(.secondary)
                    }

                    Spacer(minLength: 12)

                    if showHideButton == false {
                        Text(editButtonTitle)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(accent)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(accent.opacity(0.14))
                            )
                    }
                }
                .padding(.leading, 46)
                .padding(.top, 2)
            }
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
        @State private var optionalDateIsActive: Bool = true
        @State private var inlineDate: Date = .now.addingTimeInterval(3_600)

        var body: some View {
            ScrollView {
                VStack(spacing: 12) {
                    SimpleDateTimeInputCard(date: $date)

                    SimpleDateTimeInputCard(
                        isActive: $optionalDateIsActive,
                        date: $date,
                        title: "Optional Date",
                        subtitle: "Single card with integrated toggle and editor trigger.",
                        icon: "calendar.badge.clock",
                        accent: .blue,
                        presentationStyle: .sheet
                    )

                    SimpleDateTimeInputCard(
                        date: $inlineDate,
                        title: "Inline Editor",
                        subtitle: "Date and time editor is rendered inline.",
                        icon: "calendar",
                        accent: .orange,
                        presentationStyle: .inline
                    )
                }
                .frame(maxWidth: .infinity, alignment: .top)
                .padding()
            }
        }
    }

    #Preview {
        SimpleDateTimeInputCardPreviewHost()
    }
#endif
