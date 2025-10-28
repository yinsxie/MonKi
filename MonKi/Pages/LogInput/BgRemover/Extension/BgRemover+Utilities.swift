//
//  BgRemover+Utilities.swift
//  MonKi
//
//  Created by Yonathan Handoyo on 28/10/25.
//

import UIKit
import CoreImage

extension BackgroundRemoverViewModel {
    func normalizeImage(_ image: UIImage) -> UIImage? {
        guard let cgImage = image.cgImage else { return nil }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: .up)
    }

    func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let size = image.size
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scale = min(widthRatio, heightRatio)
        let newSize = CGSize(width: size.width * scale, height: size.height * scale)

        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
