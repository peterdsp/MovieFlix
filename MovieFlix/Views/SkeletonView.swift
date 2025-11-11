//
//  SkeletonView.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//

import UIKit
import SwiftUI

// MARK: - UIKit Skeleton View
class SkeletonView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSkeleton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSkeleton()
    }

    private func setupSkeleton() {
        backgroundColor = .systemGray5

        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        let lightColor = UIColor.systemGray5.cgColor
        let darkColor = UIColor.systemGray4.cgColor
        gradientLayer.colors = [lightColor, darkColor, lightColor]
        gradientLayer.locations = [0, 0.5, 1]

        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }

    func startAnimating() {
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.duration = 1.5
        animation.repeatCount = .infinity
        gradientLayer.add(animation, forKey: "shimmer")
    }

    func stopAnimating() {
        gradientLayer.removeAnimation(forKey: "shimmer")
    }
}

// MARK: - SwiftUI Skeleton View
struct SkeletonLoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.5), Color.gray.opacity(0.3)]),
            startPoint: isAnimating ? .leading : .trailing,
            endPoint: isAnimating ? .trailing : .leading
        )
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating.toggle()
            }
        }
    }
}

// SwiftUI Skeleton Modifier
struct SkeletonModifier: ViewModifier {
    let isLoading: Bool

    func body(content: Content) -> some View {
        if isLoading {
            content
                .hidden()
                .overlay(SkeletonLoadingView())
        } else {
            content
        }
    }
}

extension View {
    func skeleton(isLoading: Bool) -> some View {
        modifier(SkeletonModifier(isLoading: isLoading))
    }
}
