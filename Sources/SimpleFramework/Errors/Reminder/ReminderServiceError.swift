//
//  ReminderServiceError.swift
//  SimpleFramework
//
//  Errors/Reminder
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Reminder service domain errors.
public enum ReminderServiceError: LocalizedError {
    /// Notification permission is denied.
    case permissionDenied
    /// Schedule configuration is invalid.
    case invalidSchedule
    /// Generated request count exceeds configured maximum.
    case tooManyRequests

    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Notification permission is required for reminders."
        case .invalidSchedule:
            return "The selected reminder schedule is invalid."
        case .tooManyRequests:
            return "The reminder interval creates too many notifications."
        }
    }
}
