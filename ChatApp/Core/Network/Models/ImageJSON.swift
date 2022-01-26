//
//  ImageJSON.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

struct ImageJSON: Codable {

    // MARK: - Public Properties
    
    let id: Int
    let pageURL: String
    let type: String?
    let tags: String?
    let previewURL: String
    let previewWidth: Int?
    let previewHeight: Int?
    let webformatURL: String
    let webformatWidth: Int?
    let webformatHeight: Int?
    let largeImageURL: String
    let imageWidth: Int?
    let imageHeight: Int?
    let imageSize: Int?
    let views: Int
    let downloads: Int
    let collections: Int?
    let likes: Int
    let comments: Int
    let user_id: Int
    let user: String
    let userImageURL: String
}
