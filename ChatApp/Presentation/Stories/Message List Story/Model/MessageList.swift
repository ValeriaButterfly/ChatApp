//
//  MessageList.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.12.2021.
//

import Foundation

enum MessageListError: Error {
    case notFilledUser
}

// MARK: -

class MessageList {

    // MARK: - Public Properties

    var channel: Channel?

    var user: User {
        authService.user
    }

    // MARK: - Private Properties

    private let authService: AuthServiceProtocol = AuthService.shared
    private var messageService: MessageServiceProtocol {
        MessageService(for: channel)
    }
    private let networkService: NetworkServiceProtocol = NetworkService()
    private let databaseDomainMappingService: DatabaseDomainMappingServiceProtocol = DatabaseDomainMappingService()

    // MARK: - Public Methods

    func registerObserver() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        messageService.configure(with: appDelegate.database)
    }

    func getMessage(_ message: DBMessage) -> Message {
        databaseDomainMappingService.map(dbMessage: message)
    }

    func getMessageForCell(_ message: DBMessage) -> MessageCell {
        databaseDomainMappingService.map(message, user: user)
    }

    func getImageListForSend(completion: @escaping ((Result<[Image], Error>) -> Void)) {
        networkService.sendRequestForImageList(completion: { result in
            switch result {
            case .success(let imageList): completion(.success(imageList))
            case .failure(let error): completion(.failure(error))
            }
        })
    }

    func loadImageForMessage(_ text: String, completion: @escaping ((UIImage?) -> Void)) {
        if text.contains(networkService.pixabayApiImageUrl) {
            networkService.sendRequestForImage(url: text) { result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data) ?? #imageLiteral(resourceName: "imagePlaceholder")
                    completion(image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }

    func send(_ message: String, completion: @escaping ((Error?) -> Void)) {
        guard !user.fullName.isEmpty else {
            completion(MessageListError.notFilledUser)
            return
        }

        messageService.send(message: Message(content: message,
                                             created: Date(),
                                             senderId: user.identifier,
                                             senderName: user.fullName))

        completion(nil)
    }
}
