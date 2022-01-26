//
//  ImageListDelegate.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

protocol ImageListDelegate: AnyObject {

    // MARK: - Methods

    func viewDidChooseImage(_ image: UIImage, url: String)
}
