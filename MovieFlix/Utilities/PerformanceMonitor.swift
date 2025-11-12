//
//  PerformanceMonitor.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import Foundation

#if DEBUG
final class PerformanceMonitor {
    static let shared = PerformanceMonitor()

    private let monitorQueue = DispatchQueue(label: "com.MovieFlix.performance.monitor", qos: .utility)
    private let checkInterval: TimeInterval = 1.0
    private let stallThreshold: TimeInterval = 0.7
    private var timer: DispatchSourceTimer?

    private init() {}

    func start() {
        guard timer == nil else { return }

        let timer = DispatchSource.makeTimerSource(queue: monitorQueue)
        timer.schedule(deadline: .now() + checkInterval, repeating: checkInterval)
        timer.setEventHandler { [weak self] in
            self?.pingMainThread()
        }
        timer.resume()
        self.timer = timer
        AppLogger.performance.info("Performance monitor started with threshold \(self.stallThreshold, privacy: .public)s")
    }

    private func pingMainThread() {
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.main.async {
            semaphore.signal()
        }

        let deadline = DispatchTime.now() + stallThreshold
        if semaphore.wait(timeout: deadline) == .timedOut {
            AppLogger.performance.error("⚠️ Main thread unresponsive for \(self.stallThreshold, privacy: .public)s+")
        }
    }
}
#endif
