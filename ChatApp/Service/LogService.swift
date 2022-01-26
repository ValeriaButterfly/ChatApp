//
//  LogService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 22.09.2021.
//

import Foundation

struct LogService {

    static let shared = LogService()

    // MARK: - Public Methods

    func info(message: String) {
        #if DEBUG
        print("Log.i: " + message)
        #endif
    }

    func error(message: String) {
        #if DEBUG
        print("Log.e: " + message)
        #endif
    }
}
