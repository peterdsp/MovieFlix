//
//  AppLogger.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import os.log

enum AppLogger {
    static let subsystem = "com.MovieFlix.app"

    static let general = Logger(subsystem: subsystem, category: "general")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let performance = Logger(subsystem: subsystem, category: "performance")
}
