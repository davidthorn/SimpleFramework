//
//  HealthKitAutoSyncPreferenceStore.swift
//  SimpleFramework
//
//  Stores/HealthKit
//
//  Created by David Thorn on 17.02.2026.
//

import Foundation

public actor HealthKitAutoSyncPreferenceStore: HealthKitAutoSyncPreferenceStoreProtocol {
    private let key: String
    private let userDefaults: UserDefaults
    private var continuations: [UUID: AsyncStream<Bool>.Continuation]

    public init(
        key: String,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.userDefaults = userDefaults
        continuations = [:]
    }

    public func observeAutoSyncEnabled() async -> AsyncStream<Bool> {
        let streamPair = AsyncStream<Bool>.makeStream()
        let continuationID = UUID()

        continuations[continuationID] = streamPair.continuation
        streamPair.continuation.onTermination = { [weak self] _ in
            guard let self else {
                return
            }
            Task {
                await self.removeContinuation(continuationID: continuationID)
            }
        }

        let currentValue = await fetchAutoSyncEnabled()
        streamPair.continuation.yield(currentValue)

        return streamPair.stream
    }

    public func fetchAutoSyncEnabled() async -> Bool {
        userDefaults.bool(forKey: key)
    }

    public func updateAutoSyncEnabled(_ isEnabled: Bool) async {
        userDefaults.set(isEnabled, forKey: key)
        publish(isEnabled)
    }

    public func resetAutoSyncEnabled() async {
        userDefaults.removeObject(forKey: key)
        publish(false)
    }

    private func removeContinuation(continuationID: UUID) {
        continuations.removeValue(forKey: continuationID)
    }

    private func publish(_ isEnabled: Bool) {
        for continuation in continuations.values {
            continuation.yield(isEnabled)
        }
    }
}
