//
//  SettingsVolumeUnit.swift
//  SimpleFramework
//
//  Models/Preferences
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Supported units for volume input and display.
public enum SettingsVolumeUnit: String, CaseIterable, Codable, Hashable, Sendable, Identifiable {
    case milliliters
    case ounces

    /// Stable identifier used by SwiftUI lists.
    public var id: String {
        rawValue
    }

    /// Full display title used in settings selection.
    public var title: String {
        switch self {
        case .milliliters:
            "Milliliters (ml)"
        case .ounces:
            "US Ounces (oz)"
        }
    }

    /// Short unit suffix for compact display.
    public var shortLabel: String {
        switch self {
        case .milliliters:
            "ml"
        case .ounces:
            "oz"
        }
    }

    /// User-facing unit name without abbreviation.
    public var settingsValueLabel: String {
        switch self {
        case .milliliters:
            "Milliliters"
        case .ounces:
            "US Ounces"
        }
    }

    /// Formats a milliliter value in the selected unit.
    public func format(milliliters: Int) -> String {
        switch self {
        case .milliliters:
            return "\(milliliters) \(shortLabel)"
        case .ounces:
            let ouncesTimesTen = Int((Double(milliliters) / 29.5735 * 10).rounded())
            if ouncesTimesTen % 10 == 0 {
                return "\(ouncesTimesTen / 10) \(shortLabel)"
            }
            return "\(Double(ouncesTimesTen) / 10) \(shortLabel)"
        }
    }

    /// Returns editable text in the selected unit from milliliters.
    public func editableAmountText(milliliters: Int) -> String {
        switch self {
        case .milliliters:
            return "\(milliliters)"
        case .ounces:
            let ouncesTimesTen = Int((Double(milliliters) / 29.5735 * 10).rounded())
            if ouncesTimesTen % 10 == 0 {
                return "\(ouncesTimesTen / 10)"
            }
            return "\(Double(ouncesTimesTen) / 10)"
        }
    }

    /// Parses user-entered amount text into milliliters.
    public func parseAmountText(_ text: String) -> Int? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.isEmpty == false else {
            return nil
        }

        switch self {
        case .milliliters:
            guard let value = Int(trimmed), value > 0 else {
                return nil
            }
            return value
        case .ounces:
            let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
            guard let value = Double(normalized), value > 0 else {
                return nil
            }
            return Int((value * 29.5735).rounded())
        }
    }
}
