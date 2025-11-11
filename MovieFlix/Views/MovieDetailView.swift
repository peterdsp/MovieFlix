//
//  MovieDetailView.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int

    @StateObject private var viewModel: MovieDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    init(movieId: Int) {
        self.movieId = movieId
        _viewModel = StateObject(wrappedValue: MovieDetailViewModel(movieId: movieId))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Backdrop Image
                backdropSection

                // Movie Info Section
                movieInfoSection

                // Description
                descriptionSection

                // Cast
                castSection

                // Reviews
                reviewsSection

                // Similar Movies
                similarMoviesSection
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.movieDetail?.homepage != nil {
                    Button(action: shareMovie) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadMovieDetails()
        }
    }

    // MARK: - Backdrop Section
    private var backdropSection: some View {
        ZStack(alignment: .bottomTrailing) {
            if let backdropURL = viewModel.movieDetail?.backdropURL {
                AsyncImageView(url: backdropURL)
                    .aspectRatio(16/9, contentMode: .fill)
                    .skeleton(isLoading: viewModel.isLoadingDetails)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(16/9, contentMode: .fill)
                    .skeleton(isLoading: viewModel.isLoadingDetails)
            }
        }
    }

    // MARK: - Movie Info Section
    private var movieInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.movieDetail?.title ?? "Loading...")
                        .font(.title)
                        .fontWeight(.bold)
                        .skeleton(isLoading: viewModel.isLoadingDetails)

                    Text(viewModel.movieDetail?.genreNames ?? "")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .skeleton(isLoading: viewModel.isLoadingDetails)
                }

                Spacer()

                Button(action: toggleFavorite) {
                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(.pink)
                }
            }

            HStack(spacing: 20) {
                Label(viewModel.movieDetail?.formattedReleaseDate ?? "N/A", systemImage: "calendar")
                    .font(.subheadline)
                    .skeleton(isLoading: viewModel.isLoadingDetails)

                Label(viewModel.movieDetail?.formattedRuntime ?? "N/A", systemImage: "clock")
                    .font(.subheadline)
                    .skeleton(isLoading: viewModel.isLoadingDetails)
            }
            .foregroundColor(.secondary)

            // Rating
            HStack(spacing: 4) {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: starIcon(for: index))
                        .foregroundColor(.yellow)
                        .font(.caption)
                }
                Text(String(format: "%.1f", viewModel.movieDetail?.voteAverage ?? 0))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .skeleton(isLoading: viewModel.isLoadingDetails)
        }
        .padding()
    }

    // MARK: - Description Section
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let overview = viewModel.movieDetail?.overview, !overview.isEmpty {
                Text("Description")
                    .font(.headline)

                Text(overview)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .skeleton(isLoading: viewModel.isLoadingDetails)
            }
        }
        .padding()
    }

    // MARK: - Cast Section
    private var castSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let cast = viewModel.movieDetail?.credits?.cast, !cast.isEmpty {
                Text("Cast")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(cast.prefix(10)) { member in
                            CastMemberView(cast: member)
                        }
                    }
                    .padding(.horizontal)
                }
                .skeleton(isLoading: viewModel.isLoadingDetails)
            }
        }
    }

    // MARK: - Reviews Section
    private var reviewsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.reviews.isEmpty {
                Text("Reviews")
                    .font(.headline)
                    .padding(.horizontal)

                ForEach(viewModel.reviews.prefix(2)) { review in
                    ReviewCardView(review: review)
                        .padding(.horizontal)
                }
            }
        }
    }

    // MARK: - Similar Movies Section
    private var similarMoviesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.similarMovies.isEmpty {
                Text("Similar Movies")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.similarMovies.prefix(10)) { movie in
                            SimilarMovieCardView(movie: movie)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.bottom, 20)
    }

    // MARK: - Helper Functions
    private func starIcon(for index: Int) -> String {
        let rating = viewModel.movieDetail?.voteAverage ?? 0
        let fullStars = Int(rating / 2)
        let hasHalfStar = rating.truncatingRemainder(dividingBy: 2) >= 1

        if index < fullStars {
            return "star.fill"
        } else if index == fullStars && hasHalfStar {
            return "star.leadinghalf.filled"
        } else {
            return "star"
        }
    }

    private func toggleFavorite() {
        viewModel.toggleFavorite()
    }

    private func shareMovie() {
        guard let homepage = viewModel.movieDetail?.homepage,
              let url = URL(string: homepage) else { return }

        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityVC, animated: true)
        }
    }
}

// MARK: - View Model
class MovieDetailViewModel: ObservableObject {
    let movieId: Int

    @Published var movieDetail: MovieDetailResponse?
    @Published var reviews: [Review] = []
    @Published var similarMovies: [Movie] = []
    @Published var isLoadingDetails = false
    @Published var isFavorite = false

    init(movieId: Int) {
        self.movieId = movieId
        self.isFavorite = FavoritesManager.shared.isFavorite(movieId: movieId)
    }

    func loadMovieDetails() {
        isLoadingDetails = true

        // Create a dispatch group to handle parallel requests
        let group = DispatchGroup()

        // Fetch movie details (critical)
        group.enter()
        NetworkManager.shared.fetchMovieDetails(movieId: movieId) { [weak self] result in
            defer { group.leave() }
            if case .success(let details) = result {
                DispatchQueue.main.async {
                    self?.movieDetail = details
                }
            }
        }

        // Fetch reviews (non-critical)
        group.enter()
        NetworkManager.shared.fetchMovieReviews(movieId: movieId) { [weak self] result in
            defer { group.leave() }
            if case .success(let reviewResponse) = result {
                DispatchQueue.main.async {
                    self?.reviews = reviewResponse.results
                }
            }
        }

        // Fetch similar movies (non-critical)
        group.enter()
        NetworkManager.shared.fetchSimilarMovies(movieId: movieId) { [weak self] result in
            defer { group.leave() }
            if case .success(let similarResponse) = result {
                DispatchQueue.main.async {
                    self?.similarMovies = similarResponse.results
                }
            }
        }

        // Wait for critical data (movie details) to complete
        group.notify(queue: .main) { [weak self] in
            self?.isLoadingDetails = false
        }
    }

    func toggleFavorite() {
        FavoritesManager.shared.toggleFavorite(movieId: movieId)
        isFavorite = FavoritesManager.shared.isFavorite(movieId: movieId)
    }
}

// MARK: - Supporting Views

struct AsyncImageView: View {
    let url: URL?
    @StateObject private var loader = ImageLoader()

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                Color.gray.opacity(0.3)
            }
        }
        .onAppear {
            loader.load(url: url)
        }
    }
}

struct CastMemberView: View {
    let cast: Cast

    var body: some View {
        VStack(spacing: 8) {
            if let profileURL = cast.profileURL {
                AsyncImageView(url: profileURL)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
            }

            Text(cast.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 80)

            if let character = cast.character {
                Text(character)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 80)
            }
        }
    }
}

struct ReviewCardView: View {
    let review: Review

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(review.author)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(review.content)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(4)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SimilarMovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let posterURL = movie.posterURL {
                AsyncImageView(url: posterURL)
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
            }

            Text(movie.title)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
                .frame(width: 120, alignment: .leading)
        }
    }
}
