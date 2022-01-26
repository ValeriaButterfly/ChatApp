//
//  ImageCollectionViewCell.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var imageView: UIImageView!
}

// MARK: - ConfigurableView

extension ImageCollectionViewCell: ConfigurableViewProtocol {

    func configure(with model: ImageCell) {
        if let data = model.imageData {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = #imageLiteral(resourceName: "imagePlaceholder")
        }
    }
}
