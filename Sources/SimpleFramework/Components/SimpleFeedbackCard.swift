//
//  SimpleFeedbackCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleFeedbackCard: View {
    public let message: String
    public let tint: Color

    public init(
        message: String,
        tint: Color = .accentColor
    ) {
        self.message = message
        self.tint = tint
    }

    public var body: some View {
        Text(message)
            .font(.footnote)
            .foregroundStyle(tint)
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(tint.opacity(0.24), lineWidth: 1)
                    )
            )
    }
}

#if DEBUG
    #Preview {
        VStack(spacing: 10) {
            SimpleFeedbackCard(message: "All data wiped.", tint: .green)
            SimpleFeedbackCard(message: "Unable to wipe all data.", tint: .red)
        }
        .padding()
    }
#endif
