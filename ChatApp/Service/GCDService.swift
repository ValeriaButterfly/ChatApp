//
//  GCDService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 21.10.2021.
//

import Foundation

protocol MultithreadingFactory {

    // MARK: - Methods
    
    func save(_ user: User, completion: @escaping ((Error?) -> Void))
    func fetch(completion: @escaping ((User?) -> Void))
    
    func createFile(with name: String)
}

// MARK: - GSDServiceError

enum GCDServiceError: Error {
    case optionalBinding
}

// MARK: -

class GCDService: MultithreadingFactory {

    // MARK: - Private Properties

    private let logService = LogService.shared

    private var pathWithFileName: URL {
        return path(with: Constants.userDataFileName)
    }

    // MARK: - Initilizers

    init() { }

    // MARK: - Public Methods

    func save(_ user: User, completion: @escaping ((Error?) -> Void)) {
        let queue = DispatchQueue.global(qos: .userInitiated)

        queue.async { [weak self] in
            guard let self = self else { return completion(GCDServiceError.optionalBinding) }

            var property: NSMutableDictionary

            if let data = NSMutableDictionary(contentsOf: self.pathWithFileName),
                  let image = data["image"] as? Data,
                  let fullName = data["fullName"] as? String,
                  let speciality = data["speciality"] as? String,
                  let livingPlace = data["livingPlace"] as? String {

                property = data

                if image != user.image {
                    data["image"] = user.image
                }

                if fullName != user.fullName {
                    data["fullName"] = user.fullName
                }

                if speciality != user.speciality {
                    data["speciality"] = user.speciality
                }

                if livingPlace != user.livingPlace {
                    data["livingPlace"] = user.livingPlace
                }
            } else {
                property = NSMutableDictionary(capacity: 4)
                property["identifier"] = user.identifier
                property["image"] = user.image
                property["fullName"] = user.fullName
                property["speciality"] = user.speciality
                property["livingPlace"] = user.livingPlace
            }

            property.write(to: self.pathWithFileName, atomically: true)

            DispatchQueue.main.async {
                completion(nil)
            }
        }
    }

    func fetch(completion: @escaping ((User?) -> Void)) {
        let queue = DispatchQueue.global(qos: .userInitiated)

        queue.async { [weak self] in
            guard let self = self else { return DispatchQueue.main.async { completion(nil) } }
            guard let data = NSDictionary(contentsOf: self.pathWithFileName),
                  let identifier = data["identifier"] as? String,
                  let image = data["image"] as? Data,
                  let fullName = data["fullName"] as? String,
                  let speciality = data["speciality"] as? String,
                  let livingPlace = data["livingPlace"] as? String else { return DispatchQueue.main.async { completion(nil) } }
            
            let user = User(identifier: identifier,
                            image: image,
                            fullName: fullName,
                            speciality: speciality,
                            livingPlace: livingPlace)

            DispatchQueue.main.async {
                completion(user)
            }
        }
    }

    func createFile(with name: String) {

        let pathWithFileName = path(with: name)

        guard !FileManager.default.fileExists(atPath: pathWithFileName.path) else { return }

        if FileManager.default.createFile(atPath: pathWithFileName.path, contents: nil, attributes: nil) {
            logService.info(message: "File \(name) created successfully.")
            save(User(image: Data(), fullName: "", speciality: "", livingPlace: "")) { _ in }
        } else {
            logService.info(message: "File \(name) not created.")
        }
    }

    // MARK: - Private Methods

    private func path(with name: String) -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Не удалось найти путь к файлу \(name).") }
        return documentDirectory.appendingPathComponent(name)
    }
}
