//
//  Config.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import Foundation

enum Config {
    // MARK: - TMDB API Configuration
    // TODO: Replace with your actual TMDB API key
    static let apiKey = "YOUR_API_KEY_HERE"
    static let accessToken = "YOUR_ACCESS_TOKEN_HERE"

    static let baseURL = "https://api.themoviedb.org/3"
    static let imageBaseURL = "https://image.tmdb.org/t/p"

    // Image sizes
    static let backdropSize = "w780"
    static let posterSize = "w500"
    static let profileSize = "w185"
}
