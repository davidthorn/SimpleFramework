//
//  SimpleValueStepperCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 21.03.2026.
//

import SwiftUI

public struct SimpleValueStepperCard: View {
    @Binding public var value: Int

    public let title: String
    public let message: String
    public let formattedValue: String
    public let systemImage: String
    public let tint: Color
    public let range: ClosedRange<Int>
    public let step: Int

    public init(
        value: Binding<Int>,
        title: String,
        message: String,
        formattedValue: String,
        systemImage: String,
        tint: Color = .accentColor,
        range: ClosedRange<Int>,
        step: Int
    ) {
        self._value = value
        self.title = title
        self.message = message
        self.formattedValue = formattedValue
        self.systemImage = systemImage
        self.tint = tint
        self.range = range
        self.step = step
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: systemImage)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(tint)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(tint.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    Text(message)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }

            HStack(alignment: .center, spacing: 12) {
                Text(formattedValue)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))

                Spacer()

                Stepper("", value: $value, in: range, step: step)
                    .labelsHidden()
                    .tint(tint)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.88))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(tint.opacity(0.16), lineWidth: 1)
                    )
            )
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(tint.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(tint.opacity(0.14), lineWidth: 1)
                )
        )
    }
}

#if DEBUG
    #Preview {
        @Previewable @State var minutes: Int = 180

        SimpleValueStepperCard(
            value: $minutes,
            title: "Minutes Between Feeds",
            message: "Choose how long you want between reminder prompts.",
            formattedValue: "3h",
            systemImage: "clock.arrow.circlepath",
            tint: .orange,
            range: 30...480,
            step: 15
        )
        .padding()
    }
#endif
