//
//  ReminderAuthorizationStatus.swift
//  SimpleFramework
//
//  Models/Reminder
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

/// Notification authorization status used by reminder services.
public enum ReminderAuthorizationStatus: String, Codable, Sendable {
    case notDetermined
    case denied
    case authorized
    case provisional
}
