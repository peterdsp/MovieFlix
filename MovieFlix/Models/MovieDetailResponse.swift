//
//  MovieDetailResponse.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import Foundation

// MARK: - Movie Detail Response
struct MovieDetailResponse: Codable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let overview: String?
    let runtime: Int?
    let genres: [Genre]
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, homepage
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/\(Config.detailBackdropSize)\(path)")
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/\(Config.detailPosterSize)\(path)")
    }

    var formattedReleaseDate: String {
        guard
            let dateString = releaseDate,
            let date = DateFormatters.apiFormatter.date(from: dateString)
        else {
            return releaseDate ?? "N/A"
        }

        return DateFormatters.displayFormatter.string(from: date)
    }

    var formattedRuntime: String {
        guard let runtime = runtime else { return "N/A" }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }

    var genreNames: String {
        genres.map { $0.name }.joined(separator: ", ")
    }
}

// MARK: - Genre
struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

// MARK: - Credits
struct Credits: Codable {
    let cast: [Cast]
}

// MARK: - Cast
struct Cast: Codable, Identifiable {
    let id: Int
    let name: String
    let character: String?
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/\(Config.profileSize)\(path)")
    }
}
