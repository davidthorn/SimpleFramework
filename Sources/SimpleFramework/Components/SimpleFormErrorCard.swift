//
//  SimpleFormErrorCard.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import SwiftUI

public struct SimpleFormErrorCard: View {
    public let message: String
    public let tint: Color

    public init(message: String, tint: Color = .red) {
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
        SimpleFormErrorCard(message: "Unable to save settings. Try again.")
            .padding()
    }
#endif
