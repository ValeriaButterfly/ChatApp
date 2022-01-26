//
//  NetworkService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

protocol NetworkServiceProtocol {

    // MARK: - Properties

    var pixabayApiImageUrl: String { get }

    // MARK: - Methods

    func sendRequestForImageList(completion: @escaping ((Result<[Image], Error>) -> Void))
    func sendRequestForImage(url stringUrl: String, completion: @escaping ((Result<Data, Error>) -> Void))
}

// MARK: -

class NetworkService: NetworkServiceProtocol {

    // MARK: - Constants

    enum Constants: String {
        case rootKey = "Config properties"
        case pixabayApiUrl = "Pixabay Url Api"
        case pixabayApiImageUrl = "Pixabay Image Url Api"
        case pixabayToken = "Pixabay Token"
    }

    // MARK: - Public Properties

    var pixabayApiImageUrl: String {
        dictionary[Constants.pixabayApiImageUrl.rawValue] as? String ?? ""
    }

    // MARK: - Private Properties

    private var dictionary: [String: Any] {
        guard let dictionary = Bundle.main.infoDictionary?[Constants.rootKey.rawValue] as? [String: Any] else {
            fatalError("В Info.plist не найдена секция-словарь \(Constants.rootKey.rawValue)")
        }
        return dictionary
    }

    private var pixabayApiUrl: String {
        dictionary[Constants.pixabayApiUrl.rawValue] as? String ?? ""
    }

    private var pixabayToken: String {
        dictionary[Constants.pixabayToken.rawValue] as? String ?? ""
    }
    

    private let jsonDomainMappingService: JSONDomainMappingServiceProtocol = JSONDomainMappingService()

    // MARK: - Public Methods

    func sendRequestForImageList(completion: @escaping ((Result<[Image], Error>) -> Void)) {
        guard let url = URL(string: pixabayApiUrl + "?key=\(pixabayToken)&per_page=100") else {
            completion(.failure(NetworkError.invalidUrl(url: pixabayApiUrl + "?key=\(pixabayToken)")))
            return
        }

        let request = URLRequest(url: url, timeoutInterval: 15)

        let session = URLSession.shared
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
            }

            guard let self = self,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completion(.failure(NetworkError.response))
                return
            }

            do {
                let imagesJson = try self.decode(data: data)
                let imageList = self.jsonDomainMappingService.map(imageList: imagesJson.hits)
                completion(.success(imageList))
            } catch {
                completion(.failure(error))
            }

        }

        task.resume()
    }

    func sendRequestForImage(url stringUrl: String, completion: @escaping ((Result<Data, Error>) -> Void)) {
        guard let url = URL(string: stringUrl) else {
            completion(.failure(NetworkError.invalidUrl(url: stringUrl)))
            return
        }

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data else {
                completion(.failure(NetworkError.response))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }

    // MARK: - Private Methods

    private func decode(data: Data) throws -> ImagesJSON {
        do {
            let response = try JSONDecoder().decode(ImagesJSON.self, from: data)
            return response
        } catch {
            throw NetworkError.decode(type: ImagesJSON.self, catchError: error)
        }
    }
}
