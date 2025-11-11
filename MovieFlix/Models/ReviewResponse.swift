//
//  ReviewResponse.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import Foundation

// MARK: - Review Response
struct ReviewResponse: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Review
struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let content: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, author, content
        case createdAt = "created_at"
    }
}
