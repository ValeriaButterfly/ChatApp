//
//  Profile.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.12.2021.
//

import UIKit

enum ProfileError: Error {
    case cantSaveUser
}

// MARK: -

class Profile {

    // MARK: - Public Properties

    var user: User?

    // MARK: - Private Properties

    private let authService: AuthServiceProtocol = AuthService.shared
    private let networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - Public Methods

    func configure() {
        self.user = authService.user
    }

    func saveUser(completion: @escaping ((Error?) -> Void)) {
        guard let user = user else { return completion(ProfileError.cantSaveUser) }
        authService.save(user) { error in
            if error == nil {
                completion(nil)
            } else {
                completion(ProfileError.cantSaveUser)
            }
        }
    }

    func getImageList(completion: @escaping ((Result<[Image], Error>) -> Void)) {
        networkService.sendRequestForImageList { result in
            switch result {
            case .success(let imageList): completion(.success(imageList))
            case .failure(let error): completion(.failure(error))
            }
        }
    }
}
