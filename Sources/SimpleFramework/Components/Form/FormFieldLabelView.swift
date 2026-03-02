//
//  FormFieldLabelView.swift
//  SimpleFramework
//
//  Created by David Thorn on 28.02.26.
//

import SwiftUI

public struct FormFieldLabelView: View {
    internal let title: String
    internal let description: String?
    internal let trailingLabel: String?
    internal let style: FormFieldLabelStyle

    public init(
        title: String,
        description: String? = nil,
        trailingLabel: String? = nil,
        style: FormFieldLabelStyle = .default
    ) {
        self.title = title
        self.description = description
        self.trailingLabel = trailingLabel
        self.style = style
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            HStack(alignment: .firstTextBaseline) {
                Text(title)
                    .font(style.titleFont)
                    .foregroundStyle(style.titleColor)
                Spacer()
                if let trailingLabel, trailingLabel.isEmpty == false {
                    Text(trailingLabel)
                        .font(style.trailingLabelFont)
                        .foregroundStyle(style.trailingLabelTextColor)
                        .padding(.horizontal, style.trailingLabelHorizontalPadding)
                        .padding(.vertical, style.trailingLabelVerticalPadding)
                        .background(style.trailingLabelBackgroundColor)
                        .clipShape(Capsule())
                }
            }
            if let description, description.isEmpty == false {
                Text(description)
                    .font(style.descriptionFont)
                    .foregroundStyle(style.descriptionColor)
            }
        }
    }
}

#if DEBUG
#Preview {
    FormFieldLabelView(
        title: "Reference Value",
        description: "Numeric amount used as the serving baseline.",
        trailingLabel: "number"
    )
    .padding()
}
#endif
