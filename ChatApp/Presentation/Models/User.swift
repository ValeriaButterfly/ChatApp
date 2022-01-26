//
//  User.swift
//  ChatApp
//
//  Created by Valeria Muldt on 20.10.2021.
//

import UIKit

struct User {

    // MARK: - Properties

    var identifier: String
    var image: Data
    var fullName: String
    var speciality: String
    var livingPlace: String

    // MARK: - Initializers

    init(identifier: String = UUID().uuidString, image: Data, fullName: String, speciality: String, livingPlace: String) {
        self.identifier = identifier
        self.image = image
        self.fullName = fullName
        self.speciality = speciality
        self.livingPlace = livingPlace
    }
}
