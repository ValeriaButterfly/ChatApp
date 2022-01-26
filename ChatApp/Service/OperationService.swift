//
//  OperationService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 21.10.2021.
//

import Foundation

class SaveOperation: Operation {

    // MARK: - Public Properties

    var error: Error?

    // MARK: - Private Properties

    private var inputUser: User

    private let logService = LogService.shared

    private var pathWithFileName: URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Не удалось найти путь к файлу.") }
        return documentDirectory.appendingPathComponent("userData").appendingPathExtension("plist")
    }

    // MARK: - Initializers

    init(user: User) {
        self.inputUser = user
        super.init()
    }

    // MARK: - Lifecycle

    override func main() {
        if isCancelled { return }

        save(inputUser) { [weak self] error in
            self?.error = error
        }
    }

    // MARK: - Private Methods

    private func save(_ user: User, completion: @escaping ((Error?) -> Void)) {

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
            property["image"] = user.image
            property["fullName"] = user.fullName
            property["speciality"] = user.speciality
            property["livingPlace"] = user.livingPlace
        }

        property.write(to: self.pathWithFileName, atomically: true)

        OperationQueue.main.addOperation {
            completion(nil)
        }
    }
}

// MARK: -

class FetchOperation: Operation {

    // MARK: - Public Properties

    var outputUser: User?
    var error: Error?

    // MARK: - Private Properties

    private let logService = LogService.shared

    private var pathWithFileName: URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Не удалось найти путь к файлу.") }
        return documentDirectory.appendingPathComponent("userData").appendingPathExtension("plist")
    }

    // MARK: - Lifecycle

    override func main() {
        if isCancelled { return }

        fetch { [weak self] result in
            self?.outputUser = result
        }
    }

    // MARK: - Private Methods

    private func fetch(completion: @escaping ((User?) -> Void)) {
        guard let data = NSDictionary(contentsOf: self.pathWithFileName),
              let image = data["image"] as? Data,
              let fullName = data["fullName"] as? String,
              let speciality = data["speciality"] as? String,
              let livingPlace = data["livingPlace"] as? String else { return completion(nil) }
        let user = User(image: image,
                        fullName: fullName,
                        speciality: speciality,
                        livingPlace: livingPlace)

        OperationQueue.main.addOperation {
            completion(user)
        }
    }
}

// MARK: -

class OperationService: MultithreadingFactory {

    // MARK: - Private Properties

    private var pathWithFileName: URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Не удалось найти путь к файлу.") }
        return documentDirectory.appendingPathComponent("userData").appendingPathExtension("plist")
    }

    private let logService = LogService.shared

    // MARK: - Public Methods

    func save(_ user: User, completion: @escaping ((Error?) -> Void)) {
        let operation = SaveOperation(user: user)
        OperationQueue().addOperation(operation)

        operation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(operation.error)
            }
        }
    }

    func fetch(completion: @escaping ((User?) -> Void)) {
        let operation = FetchOperation()
        OperationQueue().addOperation(operation)

        operation.completionBlock = {
            OperationQueue.main.addOperation {
                completion(operation.outputUser)
            }
        }
    }

    func createFile(with name: String) {
        guard !FileManager.default.fileExists(atPath: pathWithFileName.path) else { return logService.info(message: "File exists.") }

        if FileManager.default.createFile(atPath: pathWithFileName.path, contents: nil, attributes: nil) {
            logService.info(message: "File \(name) created successfully.")
            save(User(image: Data(), fullName: "", speciality: "", livingPlace: "")) { _ in }
        } else {
            logService.info(message: "File \(name) not created.")
        }
    }
}
