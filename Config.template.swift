//
//  Config.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//
//  IMPORTANT: Copy this file to Config.swift and add your TMDB API key
//

import Foundation

enum Config {
    // MARK: - TMDB API Configuration
    // Get your API key from: https://www.themoviedb.org/settings/api
    static let apiKey = "YOUR_API_KEY_HERE"
    static let accessToken = "YOUR_ACCESS_TOKEN_HERE"

    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"

    // Image sizes
    static let backdropSize = "w780"
    static let posterSize = "w500"
    static let profileSize = "w185"
}
