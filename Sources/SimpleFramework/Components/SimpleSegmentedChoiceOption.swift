//
//  SimpleSegmentedChoiceOption.swift
//  SimpleFramework
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

public struct SimpleSegmentedChoiceOption: Identifiable, Hashable, Sendable {
    public let id: String
    public let title: String
    public let value: String

    public init(title: String, value: String) {
        self.id = value
        self.title = title
        self.value = value
    }
}
