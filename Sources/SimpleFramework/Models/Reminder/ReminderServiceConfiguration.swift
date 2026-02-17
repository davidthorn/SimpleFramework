//
//  ReminderServiceConfiguration.swift
//  SimpleFramework
//
//  Models/Reminder
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Configuration for a reminder service instance.
public struct ReminderServiceConfiguration: Sendable {
    /// Prefix used to identify scheduled notification requests managed by this service.
    public let identifierPrefix: String
    /// UserDefaults key storing whether schedule is enabled.
    public let scheduleEnabledKey: String
    /// UserDefaults key storing schedule start hour.
    public let scheduleStartHourKey: String
    /// UserDefaults key storing schedule end hour.
    public let scheduleEndHourKey: String
    /// UserDefaults key storing schedule interval.
    public let scheduleIntervalKey: String
    /// Notification title used for reminder requests.
    public let notificationTitle: String
    /// Notification body used for reminder requests.
    public let notificationBody: String
    /// Maximum reminder requests to schedule at one time.
    public let maxScheduledRequests: Int

    /// Creates reminder service configuration.
    public init(
        identifierPrefix: String,
        scheduleEnabledKey: String,
        scheduleStartHourKey: String,
        scheduleEndHourKey: String,
        scheduleIntervalKey: String,
        notificationTitle: String,
        notificationBody: String,
        maxScheduledRequests: Int = 64
    ) {
        self.identifierPrefix = identifierPrefix
        self.scheduleEnabledKey = scheduleEnabledKey
        self.scheduleStartHourKey = scheduleStartHourKey
        self.scheduleEndHourKey = scheduleEndHourKey
        self.scheduleIntervalKey = scheduleIntervalKey
        self.notificationTitle = notificationTitle
        self.notificationBody = notificationBody
        self.maxScheduledRequests = maxScheduledRequests
    }
}
