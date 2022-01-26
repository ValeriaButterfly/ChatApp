//
//  JSONDomainMappingService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

protocol JSONDomainMappingServiceProtocol {

    // MARK: - Methods

    func map(imageList: [ImageJSON]) -> [Image]
}

class JSONDomainMappingService: JSONDomainMappingServiceProtocol {

    // MARK: - Public Methods

    func map(imageList: [ImageJSON]) -> [Image] {
        imageList.map { map(imageJson: $0) }
    }

    // MARK: - Private Methods

    func map(imageJson: ImageJSON) -> Image {
        Image(previewUrl: imageJson.previewURL, webformatUrl: imageJson.webformatURL)
    }
}
