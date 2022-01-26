//
//  ImagesJSON.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

struct ImagesJSON: Codable {

    // MARK: - Public Properties
    
    let total: Int
    let totalHits: Int
    let hits: [ImageJSON]
}
