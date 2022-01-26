//
//  ThemesService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 21.10.2021.
//

import Foundation

class ThemeService {

    // MARK: - Private Properties

    private var pathWithFileName: URL {
        return path(with: Constants.themeDataFileName)
    }

    private let logService = LogService.shared

    // MARK: - Initializers

    init() { }

    // MARK: - Public Methods

    func save(_ theme: ThemeType, completion: @escaping ((Error?) -> Void)) {
        let queue = DispatchQueue.global(qos: .userInitiated)

        var property = [String: Any]()

        queue.async { [weak self] in
            guard let self = self else { return completion(GCDServiceError.optionalBinding) }
            do {
                property["type"] = theme.rawValue

                let data = try PropertyListSerialization.data(fromPropertyList: property, format: .binary, options: .zero)

                try data.write(to: self.pathWithFileName, options: .atomic)

                DispatchQueue.main.async {
                    Theme(type: theme).configure()
                    completion(nil)
                }
            } catch {
                self.logService.error(message: error.localizedDescription)
                completion(error)
            }
        }
    }

    func fetch() {
        let queue = DispatchQueue.global(qos: .userInitiated)

        queue.async { [weak self] in
            guard let self = self else { return }
            guard let data = NSDictionary(contentsOf: self.pathWithFileName),
                  let type = data["type"] as? String else { return }

            let theme = Theme(type: ThemeType(rawValue: type) ?? .classic)

            DispatchQueue.main.async {
                theme.configure()
            }
        }
    }

    // MARK: - Private Methods

    private func path(with name: String) -> URL {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Не удалось найти путь к файлу.") }
        return documentDirectory.appendingPathComponent(name)
    }
}
