//
//  SimpleSectionTitleLabel.swift
//  SimpleFramework
//
//  Created by David Thorn on 24.02.2026.
//

import SwiftUI

public struct SimpleSectionTitleLabel: View {
    public let title: String
    public let tint: Color

    public init(
        title: String,
        tint: Color = .secondary
    ) {
        self.title = title
        self.tint = tint
    }

    public var body: some View {
        Text(title.uppercased())
            .font(.caption.weight(.bold))
            .foregroundStyle(tint)
    }
}

#if DEBUG
    #Preview {
        VStack(alignment: .leading, spacing: 8) {
            SimpleSectionTitleLabel(title: "Export")
            SimpleSectionTitleLabel(title: "HealthKit Sync", tint: .orange)
        }
        .padding()
    }
#endif
