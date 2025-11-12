//
//  ImageLoader.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import UIKit
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?
    static let cache = NSCache<NSURL, UIImage>()

    func load(url: URL?) {
        guard let url = url else { return }

        // Check cache first
        if let cachedImage = Self.cache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .map { UIImage(data: $0.data)?.decoded() }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                if let downloadedImage = downloadedImage {
                    Self.cache.setObject(downloadedImage, forKey: url as NSURL)
                }
                self?.image = downloadedImage
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

// UIImageView extension for UIKit
extension UIImageView {
    func loadImage(from url: URL?, placeholder: UIImage? = nil) {
        self.image = placeholder

        guard let url = url else { return }

        // Check cache first
        if let cachedImage = ImageLoader.cache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }

            // Decode image on background thread
            DispatchQueue.global(qos: .userInitiated).async {
                guard let image = UIImage(data: data)?.decoded() else { return }

                ImageLoader.cache.setObject(image, forKey: url as NSURL)

                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }

    private static var cache: NSCache<NSURL, UIImage> {
        return ImageLoader.cache
    }
}
