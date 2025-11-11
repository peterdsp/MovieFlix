//
//  NetworkManager.swift
//  MovieFlix
//
//  Created on 11/11/2025.
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
        let urlString = "\(Config.baseURL)/movie/\(movieId)?api_key=\(Config.apiKey)&append_to_response=credits"
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

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.serverError("Status code: \(httpResponse.statusCode)")))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.invalidResponse))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }.resume()
    }
}
