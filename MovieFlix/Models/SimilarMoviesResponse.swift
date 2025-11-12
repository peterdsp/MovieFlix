//
//  SimilarMoviesResponse.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import Foundation

// MARK: - Similar Movies Response
struct SimilarMoviesResponse: Codable {
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
