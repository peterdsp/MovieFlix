//
//  Movie.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import Foundation

// MARK: - Movie List Response
struct MovieListResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Movie
struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let overview: String?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }

    var backdropURL: URL? {
        guard let path = backdropPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/\(Config.listBackdropSize)\(path)")
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "\(Config.imageBaseURL)/\(Config.listPosterSize)\(path)")
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

    var rating: Double {
        return voteAverage
    }
}
