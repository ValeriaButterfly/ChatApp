//
//  ImageCell.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

protocol ImageCellConfigurationProtocol: AnyObject {

    // MARK: - Properties

    var imageData: Data? { get set }
}

// MARK: -

class ImageCell: ImageCellConfigurationProtocol {

    // MARK: - Properties

    var imageData: Data?

    // MARK: - Initializers

    init(data: Data?) {
        self.imageData = data
    }
}
