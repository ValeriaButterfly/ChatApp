//
//  NetworkError.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl(url: String)
    case response
    case decode(type: Any, catchError: Error)
}

// MARK: - LocalizedError

extension NetworkError: LocalizedError {

    // MARK: - Public Properties

    var errorDescription: String? {
        switch self {
        case .invalidUrl(let url): return "Invalid URL - \(url)"
        case .response: return "Invalid response"
        case .decode(let type, let error): return "Can not decode \(type.self). \(error.localizedDescription)"
        }
    }
}
