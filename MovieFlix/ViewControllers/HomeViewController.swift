//
//  HomeViewController.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    // MARK: - Properties
    private var movies: [Movie] = []
    private var currentPage = 1
    private var isLoading = false
    private var isSearching = false
    private var searchQuery = ""
    private var searchWorkItem: DispatchWorkItem?

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
        guard !isLoading else { return }
        isLoading = true

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
                if self.currentPage == 1 {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                self.tableView.reloadData()

            case .failure(let error):
                self.showError(error)
            }
        }
    }

    // MARK: - Search Movies
    private func searchMovies() {
        guard !isLoading, !searchQuery.isEmpty else { return }
        isLoading = true

        if movies.isEmpty {
            loadingIndicator.startAnimating()
        }

        NetworkManager.shared.searchMovies(query: searchQuery, page: currentPage) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            self.loadingIndicator.stopAnimating()

            switch result {
            case .success(let response):
                if self.currentPage == 1 {
                    self.movies = response.results
                } else {
                    self.movies.append(contentsOf: response.results)
                }
                self.tableView.reloadData()

            case .failure(let error):
                self.showError(error)
            }
        }
    }

    // MARK: - Refresh Movies
    @objc private func refreshMovies() {
        currentPage = 1
        if isSearching {
            searchMovies()
        } else {
            loadPopularMovies()
        }
    }

    // MARK: - Load More Movies
    private func loadMoreMovies() {
        currentPage += 1
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
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]
        let isFavorite = FavoritesManager.shared.isFavorite(movieId: movie.id)
        cell.configure(with: movie, isFavorite: isFavorite)
        cell.delegate = self

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

            if query.isEmpty {
                self.isSearching = false
                self.searchQuery = ""
                self.currentPage = 1
                self.loadPopularMovies()
            } else {
                self.isSearching = true
                self.searchQuery = query
                self.currentPage = 1
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
