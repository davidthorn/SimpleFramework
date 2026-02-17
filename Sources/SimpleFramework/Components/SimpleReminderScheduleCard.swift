//
//  SimpleReminderScheduleCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

/// Shared reminder schedule form card with enable toggle and start/end/interval controls.
public struct SimpleReminderScheduleCard: View {
    @Binding public var isEnabled: Bool
    @Binding public var startHour: Int
    @Binding public var endHour: Int
    @Binding public var intervalMinutes: Int

    public let title: String
    public let enabledTitle: String
    public let enabledMessage: String
    public let startHourTitle: String
    public let endHourTitle: String
    public let intervalTitle: String
    public let disabledMessage: String
    public let tint: Color
    public let startValueTint: Color
    public let endValueTint: Color
    public let intervalValueTint: Color
    public let isInputEnabled: Bool
    public let hourRange: ClosedRange<Int>
    public let intervalRange: ClosedRange<Int>
    public let intervalStep: Int

    /// Creates a reminder schedule card.
    public init(
        isEnabled: Binding<Bool>,
        startHour: Binding<Int>,
        endHour: Binding<Int>,
        intervalMinutes: Binding<Int>,
        title: String = "Schedule",
        enabledTitle: String = "Enabled",
        enabledMessage: String = "Enable scheduled reminders.",
        startHourTitle: String = "Start Hour",
        endHourTitle: String = "End Hour",
        intervalTitle: String = "Interval Minutes",
        disabledMessage: String = "Enable reminders to configure start, end, and interval.",
        tint: Color = .accentColor,
        startValueTint: Color = .accentColor,
        endValueTint: Color = .green,
        intervalValueTint: Color = .orange,
        isInputEnabled: Bool = true,
        hourRange: ClosedRange<Int> = 0...23,
        intervalRange: ClosedRange<Int> = 30...360,
        intervalStep: Int = 30
    ) {
        _isEnabled = isEnabled
        _startHour = startHour
        _endHour = endHour
        _intervalMinutes = intervalMinutes
        self.title = title
        self.enabledTitle = enabledTitle
        self.enabledMessage = enabledMessage
        self.startHourTitle = startHourTitle
        self.endHourTitle = endHourTitle
        self.intervalTitle = intervalTitle
        self.disabledMessage = disabledMessage
        self.tint = tint
        self.startValueTint = startValueTint
        self.endValueTint = endValueTint
        self.intervalValueTint = intervalValueTint
        self.isInputEnabled = isInputEnabled
        self.hourRange = hourRange
        self.intervalRange = intervalRange
        self.intervalStep = intervalStep
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            SimpleToggleCardRow(
                isOn: $isEnabled,
                title: enabledTitle,
                message: enabledMessage,
                systemImage: "bell.badge",
                tint: tint,
                isEnabled: isInputEnabled
            )

            if isEnabled {
                SimpleReminderScheduleStepperRow(
                    value: $startHour,
                    title: startHourTitle,
                    valueTint: startValueTint,
                    range: hourRange,
                    step: 1,
                    isEnabled: isInputEnabled
                )

                SimpleReminderScheduleStepperRow(
                    value: $endHour,
                    title: endHourTitle,
                    valueTint: endValueTint,
                    range: hourRange,
                    step: 1,
                    isEnabled: isInputEnabled
                )

                SimpleReminderScheduleStepperRow(
                    value: $intervalMinutes,
                    title: intervalTitle,
                    valueTint: intervalValueTint,
                    range: intervalRange,
                    step: intervalStep,
                    isEnabled: isInputEnabled
                )
            } else {
                Text(disabledMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(inputBackground)
            }
        }
        .padding(14)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color.secondary.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.primary.opacity(0.08), lineWidth: 1)
            )
    }

    private var inputBackground: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(Color.white.opacity(0.75))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color.primary.opacity(0.1), lineWidth: 1)
            )
    }
}

private struct SimpleReminderScheduleStepperRow: View {
    @Binding var value: Int

    let title: String
    let valueTint: Color
    let range: ClosedRange<Int>
    let step: Int
    let isEnabled: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))

            Spacer()

            Text("\(value)")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(valueTint)
                .frame(minWidth: 36, alignment: .trailing)

            Stepper("", value: $value, in: range, step: step)
                .labelsHidden()
                .disabled(isEnabled == false)
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
        .opacity(isEnabled ? 1 : 0.6)
    }
}

#if DEBUG
    private struct SimpleReminderScheduleCardPreviewHost: View {
        @State private var isEnabled = true
        @State private var startHour = 8
        @State private var endHour = 20
        @State private var interval = 120

        var body: some View {
            SimpleReminderScheduleCard(
                isEnabled: $isEnabled,
                startHour: $startHour,
                endHour: $endHour,
                intervalMinutes: $interval
            )
            .padding()
        }
    }

    #Preview {
        SimpleReminderScheduleCardPreviewHost()
    }
#endif
