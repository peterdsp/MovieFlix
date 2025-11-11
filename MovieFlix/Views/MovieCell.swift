//
//  MovieCell.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import UIKit

protocol MovieCellDelegate: AnyObject {
    func didTapFavorite(for movieId: Int)
}

class MovieCell: UITableViewCell {
    static let identifier = "MovieCell"

    weak var delegate: MovieCellDelegate?
    private var movieId: Int?

    // MARK: - UI Components
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let skeletonImageView: SkeletonView = {
        let view = SkeletonView()
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ratingStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .systemPink
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return button
    }()

    private let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        layer.locations = [0.3, 1.0]
        return layer
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = backdropImageView.bounds
    }

    // MARK: - Setup UI
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(backdropImageView)
        contentView.addSubview(skeletonImageView)
        backdropImageView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(ratingStackView)
        contentView.addSubview(favoriteButton)

        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            backdropImageView.heightAnchor.constraint(equalToConstant: 200),
            backdropImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            skeletonImageView.topAnchor.constraint(equalTo: backdropImageView.topAnchor),
            skeletonImageView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor),
            skeletonImageView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor),
            skeletonImageView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -4),

            dateLabel.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor, constant: 12),
            dateLabel.bottomAnchor.constraint(equalTo: ratingStackView.topAnchor, constant: -4),

            ratingStackView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor, constant: 12),
            ratingStackView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -12),
            ratingStackView.heightAnchor.constraint(equalToConstant: 16),

            favoriteButton.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor, constant: -8),
            favoriteButton.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -8),
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Configure Cell
    func configure(with movie: Movie, isFavorite: Bool, isLoading: Bool = false) {
        movieId = movie.id
        titleLabel.text = movie.title
        dateLabel.text = movie.formattedReleaseDate
        favoriteButton.isSelected = isFavorite

        if isLoading {
            showSkeleton()
        } else {
            hideSkeleton()
            backdropImageView.loadImage(from: movie.backdropURL)
            configureRating(movie.rating)
        }
    }

    private func configureRating(_ rating: Double) {
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let fullStars = Int(rating / 2)
        let hasHalfStar = rating.truncatingRemainder(dividingBy: 2) >= 1

        for i in 0..<5 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .systemYellow

            if i < fullStars {
                imageView.image = UIImage(systemName: "star.fill")
            } else if i == fullStars && hasHalfStar {
                imageView.image = UIImage(systemName: "star.leadinghalf.filled")
            } else {
                imageView.image = UIImage(systemName: "star")
            }

            imageView.widthAnchor.constraint(equalToConstant: 16).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
            ratingStackView.addArrangedSubview(imageView)
        }
    }

    private func showSkeleton() {
        skeletonImageView.isHidden = false
        skeletonImageView.startAnimating()
        backdropImageView.image = nil
        titleLabel.alpha = 0.3
        dateLabel.alpha = 0.3
        ratingStackView.alpha = 0.3
    }

    private func hideSkeleton() {
        skeletonImageView.stopAnimating()
        skeletonImageView.isHidden = true
        titleLabel.alpha = 1.0
        dateLabel.alpha = 1.0
        ratingStackView.alpha = 1.0
    }

    @objc private func favoriteButtonTapped() {
        guard let movieId = movieId else { return }
        delegate?.didTapFavorite(for: movieId)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        backdropImageView.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        ratingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        favoriteButton.isSelected = false
        movieId = nil
    }
}
