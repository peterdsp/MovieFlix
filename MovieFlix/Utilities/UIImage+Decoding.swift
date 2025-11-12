//
//  UIImage+Decoding.swift
//  MovieFlix
//
//  Created on 11/11/2025.
//  Copyrights 2025 @Petros Dhespollari
//

import UIKit

extension UIImage {
    func decoded() -> UIImage {
        guard let cgImage = cgImage else { return self }

        let size = CGSize(width: cgImage.width, height: cgImage.height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue

        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            return self
        }

        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        guard let decompressedImage = context.makeImage() else { return self }
        return UIImage(cgImage: decompressedImage, scale: scale, orientation: imageOrientation)
    }
}
