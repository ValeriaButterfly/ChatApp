//
//  AuthService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 28.10.2021.
//

import Foundation

protocol AuthServiceProtocol: AnyObject {

    // MARK: - Propteries

    var user: User { get }

    // MARK: - Methods

    func configure()

    func save(_ user: User, completion: @escaping ((Error?) -> Void))
}

// MARK: -

class AuthService: AuthServiceProtocol {

    static let shared: AuthServiceProtocol = AuthService()

    // MARK: - Public Properties

    var user: User { authUser }

    // MARK: - Private Properties

    private var authUser: User = User(image: Data(),
                                      fullName: "",
                                      speciality: "",
                                      livingPlace: "")

    private let gcdService: MultithreadingFactory = GCDService()

    // MARK: - Initilizers

    private init() { }

    // MARK: - Public Methods

    func configure() {
        gcdService.fetch { [weak self] result in
            guard let self = self,
                  let result = result else { return }

            DispatchQueue.main.async {
                self.authUser = result
            }
        }
    }

    func save(_ user: User, completion: @escaping ((Error?) -> Void)) {
        authUser = user
        gcdService.save(user, completion: completion)
    }
}
