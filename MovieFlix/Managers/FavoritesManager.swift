//
//  FavoritesManager.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()

    private let favoritesKey = "favoriteMovies"
    private var favoriteMovieIds: Set<Int> = []

    private init() {
        loadFavorites()
    }

    // MARK: - Check if Movie is Favorite
    func isFavorite(movieId: Int) -> Bool {
        return favoriteMovieIds.contains(movieId)
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(movieId: Int) {
        if favoriteMovieIds.contains(movieId) {
            favoriteMovieIds.remove(movieId)
        } else {
            favoriteMovieIds.insert(movieId)
        }
        saveFavorites()
    }

    // MARK: - Save to UserDefaults
    private func saveFavorites() {
        let array = Array(favoriteMovieIds)
        UserDefaults.standard.set(array, forKey: favoritesKey)
    }

    // MARK: - Load from UserDefaults
    private func loadFavorites() {
        if let savedIds = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] {
            favoriteMovieIds = Set(savedIds)
        }
    }
}
