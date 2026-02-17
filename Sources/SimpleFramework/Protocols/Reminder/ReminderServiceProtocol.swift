//
//  ReminderServiceProtocol.swift
//  SimpleFramework
//
//  Protocols/Reminder
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Defines authorization and schedule management operations for local reminders.
public protocol ReminderServiceProtocol: Sendable {
    /// Provides authorization status updates.
    func observeAuthorizationStatus() async -> AsyncStream<ReminderAuthorizationStatus>
    /// Provides schedule updates.
    func observeSchedule() async -> AsyncStream<ReminderSchedule?>
    /// Returns current authorization status.
    func fetchAuthorizationStatus() async -> ReminderAuthorizationStatus
    /// Returns current reminder schedule.
    func fetchSchedule() async -> ReminderSchedule?
    /// Requests local notification authorization.
    func requestAuthorization() async throws -> ReminderAuthorizationStatus
    /// Persists and applies a reminder schedule.
    func updateSchedule(_ schedule: ReminderSchedule?) async throws
    /// Clears persisted schedule and pending reminder requests.
    func clearSchedule() async throws
}
