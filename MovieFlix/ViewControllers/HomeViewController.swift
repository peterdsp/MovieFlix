//
//  HomeViewController.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import UIKit
import SwiftUI
import QuartzCore

class HomeViewController: UIViewController {

    // MARK: - Properties
    private var movies: [Movie] = []
    private var currentPage = 1
    private var isLoading = false
    private var isSearching = false
    private var searchQuery = ""
    private var searchWorkItem: DispatchWorkItem?
    private var showSkeletonCells = true

    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .systemBackground
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"
        controller.searchBar.delegate = self
        return controller
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        return control
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPopularMovies()
    }

    // MARK: - Setup UI
    private func setupUI() {
        title = "MovieFlix"
        view.backgroundColor = .systemBackground

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
        tableView.refreshControl = refreshControl

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Load Popular Movies
    private func loadPopularMovies() {
        guard !isLoading else {
            AppLogger.general.debug("Skipped popular load, another request is in flight (page \(self.currentPage))")
            return
        }
        isLoading = true
        AppLogger.general.info("[HOME] Loading popular movies page \(self.currentPage)")

        if movies.isEmpty {
            loadingIndicator.startAnimating()
        }

        NetworkManager.shared.fetchPopularMovies(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.loadingIndicator.stopAnimating()
            self.refreshControl.endRefreshing()

            switch result {
            case .success(let response):
                AppLogger.general.info("[HOME] Received \(response.results.count) movies for page \(self.currentPage)")
                self.showSkeletonCells = false
                if self.currentPage == 1 {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                self.reloadTableView()

            case .failure(let error):
                AppLogger.general.error("[HOME] Failed to load popular movies: \(error.localizedDescription, privacy: .public)")
                self.showSkeletonCells = false
                self.showError(error)
            }
        }
    }

    // MARK: - Search Movies
    private func searchMovies() {
        guard !isLoading else {
            AppLogger.general.debug("Skipped search fetch, another request is in flight (page \(self.currentPage))")
            return
        }

        guard !searchQuery.isEmpty else { return }
        isLoading = true
        AppLogger.general.info("[HOME] Searching '\(self.searchQuery, privacy: .public)' page \(self.currentPage)")

        if movies.isEmpty {
            loadingIndicator.startAnimating()
        }

        NetworkManager.shared.searchMovies(query: searchQuery, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.loadingIndicator.stopAnimating()

            switch result {
            case .success(let response):
                AppLogger.general.info("[HOME] Search returned \(response.results.count) movies for page \(self.currentPage)")
                self.showSkeletonCells = false
                if self.currentPage == 1 {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                self.reloadTableView()

            case .failure(let error):
                AppLogger.general.error("[HOME] Search failed: \(error.localizedDescription, privacy: .public)")
                self.showSkeletonCells = false
                self.showError(error)
            }
        }
    }

    // MARK: - Refresh Movies
    @objc private func refreshMovies() {
        let mode = self.isSearching ? "search" : "popular"
        AppLogger.general.info("[HOME] Refresh triggered. Current mode: \(mode)")
        currentPage = 1
        showSkeletonCells = true
        movies.removeAll()
        tableView.reloadData()
        if isSearching {
            searchMovies()
        } else {
            loadPopularMovies()
        }
    }

    // MARK: - Load More Movies
    private func loadMoreMovies() {
        guard !isLoading else { return }
        currentPage += 1
        AppLogger.general.info("[HOME] Loading more movies. Next page: \(self.currentPage)")
        if isSearching {
            searchMovies()
        } else {
            loadPopularMovies()
        }
    }

    // MARK: - Error Handling
    private func showError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showSkeletonCells && movies.isEmpty ? 5 : movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        if showSkeletonCells && movies.isEmpty {
            // Show skeleton cell while loading
            let placeholderMovie = Movie(
                id: indexPath.row,
                title: "Loading...",
                backdropPath: nil,
                posterPath: nil,
                releaseDate: nil,
                voteAverage: 0,
                overview: nil
            )
            cell.configure(with: placeholderMovie, isFavorite: false, isLoading: true)
        } else {
            let movie = movies[indexPath.row]
            let isFavorite = FavoritesManager.shared.isFavorite(movieId: movie.id)
            cell.configure(with: movie, isFavorite: isFavorite, isLoading: false)
            cell.delegate = self
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let detailView = MovieDetailView(movieId: movie.id)
        let hostingController = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Infinite scrolling: Load more when near the bottom
        if indexPath.row == movies.count - 3 && !isLoading {
            loadMoreMovies()
        }
    }
}

// MARK: - UISearchResultsUpdating
extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchWorkItem?.cancel()

        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            let query = searchController.searchBar.text ?? ""
            AppLogger.general.debug("Search query changed to '\(query, privacy: .public)'")

            if query.isEmpty {
                self.isSearching = false
                self.searchQuery = ""
                self.currentPage = 1
                self.showSkeletonCells = true
                self.movies.removeAll()
                self.tableView.reloadData()
                self.loadPopularMovies()
            } else {
                self.isSearching = true
                self.searchQuery = query
                self.currentPage = 1
                self.showSkeletonCells = true
                self.movies.removeAll()
                self.tableView.reloadData()
                self.searchMovies()
            }
        }

        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchQuery = ""
        currentPage = 1
        showSkeletonCells = true
        movies.removeAll()
        tableView.reloadData()
        loadPopularMovies()
    }
}

// MARK: - MovieCellDelegate
extension HomeViewController: MovieCellDelegate {
    func didTapFavorite(for movieId: Int) {
        FavoritesManager.shared.toggleFavorite(movieId: movieId)

        // Refresh the cell
        if let index = movies.firstIndex(where: { $0.id == movieId }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

// MARK: - Performance helpers
private extension HomeViewController {
    func reloadTableView() {
        #if DEBUG
        let start = CACurrentMediaTime()
        tableView.reloadData()
        let duration = CACurrentMediaTime() - start
        let formatted = String(format: "%.3f", duration)
        if duration > 0.05 {
            AppLogger.performance.error("[PERF] tableView.reloadData took \(formatted, privacy: .public)s for \(self.movies.count) rows")
        } else {
            AppLogger.performance.debug("[PERF] tableView.reloadData took \(formatted, privacy: .public)s for \(self.movies.count) rows")
        }
        #else
        tableView.reloadData()
        #endif
    }
}
