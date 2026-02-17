//
//  ReminderSchedule.swift
//  SimpleFramework
//
//  Models/Reminder
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Daily reminder schedule with a start window, end window, and interval.
public struct ReminderSchedule: Codable, Hashable, Sendable {
    /// Schedule window start hour in 24-hour format.
    public let startHour: Int
    /// Schedule window end hour in 24-hour format.
    public let endHour: Int
    /// Reminder interval in minutes.
    public let intervalMinutes: Int
    /// Whether reminders are currently enabled.
    public let isEnabled: Bool

    /// Creates a reminder schedule.
    public init(
        startHour: Int,
        endHour: Int,
        intervalMinutes: Int,
        isEnabled: Bool
    ) {
        self.startHour = startHour
        self.endHour = endHour
        self.intervalMinutes = intervalMinutes
        self.isEnabled = isEnabled
    }
}
