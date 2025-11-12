//
//  NetworkManager.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(String)
}

class NetworkManager {
    static let shared = NetworkManager()

    private init() {}

    // MARK: - Fetch Popular Movies
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieListResponse, Error>) -> Void) {
        let urlString = "\(Config.baseURL)/movie/popular?api_key=\(Config.apiKey)&page=\(page)"
        performRequest(urlString: urlString, completion: completion)
    }

    // MARK: - Search Movies
    func searchMovies(query: String, page: Int, completion: @escaping (Result<MovieListResponse, Error>) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        let urlString = "\(Config.baseURL)/search/movie?api_key=\(Config.apiKey)&query=\(encodedQuery)&page=\(page)"
        performRequest(urlString: urlString, completion: completion)
    }

    // MARK: - Fetch Movie Details
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<MovieDetailResponse, Error>) -> Void) {
        let urlString = "\(Config.baseURL)/movie/\(movieId)?api_key=\(Config.apiKey)"
        performRequest(urlString: urlString, completion: completion)
    }

    // MARK: - Fetch Movie Credits
    func fetchMovieCredits(movieId: Int, completion: @escaping (Result<Credits, Error>) -> Void) {
        let urlString = "\(Config.baseURL)/movie/\(movieId)/credits?api_key=\(Config.apiKey)"
        performRequest(urlString: urlString, completion: completion)
    }

    // MARK: - Fetch Movie Reviews
    func fetchMovieReviews(movieId: Int, completion: @escaping (Result<ReviewResponse, Error>) -> Void) {
        let urlString = "\(Config.baseURL)/movie/\(movieId)/reviews?api_key=\(Config.apiKey)&page=1"
        performRequest(urlString: urlString, completion: completion)
    }

    // MARK: - Fetch Similar Movies
    func fetchSimilarMovies(movieId: Int, completion: @escaping (Result<SimilarMoviesResponse, Error>) -> Void) {
        let urlString = "\(Config.baseURL)/movie/\(movieId)/similar?api_key=\(Config.apiKey)&page=1"
        performRequest(urlString: urlString, completion: completion)
    }

    // MARK: - Generic Request Handler
    private func performRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        #if DEBUG
        let startTime = Date()
        AppLogger.network.info("[NETWORK] Request started: \(url.absoluteString, privacy: .public)")
        #endif

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                #if DEBUG
                AppLogger.network.error("[NETWORK] Request failed: \(url.absoluteString, privacy: .public) error: \(error.localizedDescription, privacy: .public)")
                #endif
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                #if DEBUG
                AppLogger.network.error("[NETWORK] Invalid response object for: \(url.absoluteString, privacy: .public)")
                #endif
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                #if DEBUG
                AppLogger.network.error("[NETWORK] HTTP \(httpResponse.statusCode) for: \(url.absoluteString, privacy: .public)")
                #endif
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.serverError("Status code: \(httpResponse.statusCode)")))
                }
                return
            }

            guard let data = data else {
                #if DEBUG
                AppLogger.network.error("[NETWORK] Empty data for: \(url.absoluteString, privacy: .public)")
                #endif
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                #if DEBUG
                let duration = Date().timeIntervalSince(startTime)
                AppLogger.network.info("[NETWORK] Request succeeded: \(url.absoluteString, privacy: .public) in \(duration, format: .fixed(precision: 2), privacy: .public)s")
                #endif
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                #if DEBUG
                AppLogger.network.error("[NETWORK] Decoding error for: \(url.absoluteString, privacy: .public)")
                #endif
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
}
