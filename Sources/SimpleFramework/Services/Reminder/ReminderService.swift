//
//  ReminderService.swift
//  SimpleFramework
//
//  Services/Reminder
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation
import UserNotifications

/// Actor-backed concrete local reminder service.
public actor ReminderService: ReminderServiceProtocol {
    private let notificationCenter: UNUserNotificationCenter
    private let calendar: Calendar
    private let userDefaults: UserDefaults
    private let configuration: ReminderServiceConfiguration

    private var authorizationContinuations: [UUID: AsyncStream<ReminderAuthorizationStatus>.Continuation]
    private var scheduleContinuations: [UUID: AsyncStream<ReminderSchedule?>.Continuation]

    /// Creates a reminder service with app-specific configuration.
    public init(
        configuration: ReminderServiceConfiguration,
        notificationCenter: UNUserNotificationCenter = .current(),
        calendar: Calendar = .current,
        userDefaults: UserDefaults = .standard
    ) {
        self.configuration = configuration
        self.notificationCenter = notificationCenter
        self.calendar = calendar
        self.userDefaults = userDefaults
        authorizationContinuations = [:]
        scheduleContinuations = [:]
    }

    /// Provides authorization status updates.
    public func observeAuthorizationStatus() async -> AsyncStream<ReminderAuthorizationStatus> {
        let streamPair = AsyncStream<ReminderAuthorizationStatus>.makeStream()
        let id = UUID()
        authorizationContinuations[id] = streamPair.continuation
        streamPair.continuation.onTermination = { [weak self] _ in
            guard let self else {
                return
            }
            Task {
                await self.removeAuthorizationContinuation(id: id)
            }
        }

        let status = await fetchAuthorizationStatus()
        streamPair.continuation.yield(status)
        return streamPair.stream
    }

    /// Provides schedule updates.
    public func observeSchedule() async -> AsyncStream<ReminderSchedule?> {
        let streamPair = AsyncStream<ReminderSchedule?>.makeStream()
        let id = UUID()
        scheduleContinuations[id] = streamPair.continuation
        streamPair.continuation.onTermination = { [weak self] _ in
            guard let self else {
                return
            }
            Task {
                await self.removeScheduleContinuation(id: id)
            }
        }

        let schedule = await fetchSchedule()
        streamPair.continuation.yield(schedule)
        return streamPair.stream
    }

    /// Returns current authorization status.
    public func fetchAuthorizationStatus() async -> ReminderAuthorizationStatus {
        let settings = await notificationCenter.notificationSettings()
        let status = mapAuthorizationStatus(settings.authorizationStatus)
        publishAuthorizationStatus(status)
        return status
    }

    /// Returns current reminder schedule.
    public func fetchSchedule() async -> ReminderSchedule? {
        guard userDefaults.object(forKey: configuration.scheduleEnabledKey) != nil else {
            return nil
        }

        let isEnabled = userDefaults.bool(forKey: configuration.scheduleEnabledKey)
        let startHour = userDefaults.integer(forKey: configuration.scheduleStartHourKey)
        let endHour = userDefaults.integer(forKey: configuration.scheduleEndHourKey)
        let intervalMinutes = userDefaults.integer(forKey: configuration.scheduleIntervalKey)

        return ReminderSchedule(
            startHour: startHour,
            endHour: endHour,
            intervalMinutes: intervalMinutes,
            isEnabled: isEnabled
        )
    }

    /// Requests local notification authorization.
    public func requestAuthorization() async throws -> ReminderAuthorizationStatus {
        _ = try await notificationCenter.requestAuthorization(options: [.alert, .badge, .sound])
        return await fetchAuthorizationStatus()
    }

    /// Persists and applies a reminder schedule.
    public func updateSchedule(_ schedule: ReminderSchedule?) async throws {
        try await clearSchedule()

        guard let schedule else {
            clearScheduleDefaults()
            publishSchedule(nil)
            return
        }

        guard schedule.isEnabled else {
            clearScheduleDefaults()
            publishSchedule(nil)
            return
        }

        let permissionStatus = await fetchAuthorizationStatus()
        guard permissionStatus == .authorized || permissionStatus == .provisional else {
            throw ReminderServiceError.permissionDenied
        }

        let minutes = buildScheduleMinutes(from: schedule)
        guard minutes.isEmpty == false else {
            throw ReminderServiceError.invalidSchedule
        }
        guard minutes.count <= configuration.maxScheduledRequests else {
            throw ReminderServiceError.tooManyRequests
        }

        for minute in minutes {
            let hour = minute / 60
            let minuteOfHour = minute % 60

            var components = DateComponents()
            components.hour = hour
            components.minute = minuteOfHour

            let content = UNMutableNotificationContent()
            content.title = configuration.notificationTitle
            content.body = configuration.notificationBody
            content.sound = .default

            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            let request = UNNotificationRequest(
                identifier: "\(configuration.identifierPrefix).\(hour).\(minuteOfHour)",
                content: content,
                trigger: trigger
            )

            try await notificationCenter.add(request)
        }

        userDefaults.set(schedule.isEnabled, forKey: configuration.scheduleEnabledKey)
        userDefaults.set(schedule.startHour, forKey: configuration.scheduleStartHourKey)
        userDefaults.set(schedule.endHour, forKey: configuration.scheduleEndHourKey)
        userDefaults.set(schedule.intervalMinutes, forKey: configuration.scheduleIntervalKey)
        publishSchedule(schedule)
    }

    /// Clears persisted schedule and pending reminder requests.
    public func clearSchedule() async throws {
        let pendingRequests = await notificationCenter.pendingNotificationRequests()
        let reminderIDs = pendingRequests.compactMap { request -> String? in
            if request.identifier.hasPrefix(configuration.identifierPrefix) {
                return request.identifier
            }
            return nil
        }

        notificationCenter.removePendingNotificationRequests(withIdentifiers: reminderIDs)
        clearScheduleDefaults()
        publishSchedule(nil)
    }

    private func removeAuthorizationContinuation(id: UUID) {
        authorizationContinuations.removeValue(forKey: id)
    }

    private func removeScheduleContinuation(id: UUID) {
        scheduleContinuations.removeValue(forKey: id)
    }

    private func publishAuthorizationStatus(_ status: ReminderAuthorizationStatus) {
        for continuation in authorizationContinuations.values {
            continuation.yield(status)
        }
    }

    private func publishSchedule(_ schedule: ReminderSchedule?) {
        for continuation in scheduleContinuations.values {
            continuation.yield(schedule)
        }
    }

    private func clearScheduleDefaults() {
        userDefaults.removeObject(forKey: configuration.scheduleEnabledKey)
        userDefaults.removeObject(forKey: configuration.scheduleStartHourKey)
        userDefaults.removeObject(forKey: configuration.scheduleEndHourKey)
        userDefaults.removeObject(forKey: configuration.scheduleIntervalKey)
    }

    private func buildScheduleMinutes(from schedule: ReminderSchedule) -> [Int] {
        guard schedule.intervalMinutes > 0 else {
            return []
        }

        guard (0...23).contains(schedule.startHour), (0...23).contains(schedule.endHour) else {
            return []
        }

        let startMinute = schedule.startHour * 60
        let endMinute = schedule.endHour * 60
        guard startMinute < endMinute else {
            return []
        }

        var minutes: [Int] = []
        var currentMinute = startMinute

        while currentMinute < endMinute {
            let date = Date(timeIntervalSince1970: TimeInterval(currentMinute * 60))
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            minutes.append((hour * 60) + minute)
            currentMinute += schedule.intervalMinutes
        }

        return minutes
    }

    private func mapAuthorizationStatus(_ status: UNAuthorizationStatus) -> ReminderAuthorizationStatus {
        switch status {
        case .notDetermined:
            return .notDetermined
        case .denied:
            return .denied
        case .authorized:
            return .authorized
        case .provisional:
            return .provisional
        case .ephemeral:
            return .authorized
        @unknown default:
            return .denied
        }
    }
}
