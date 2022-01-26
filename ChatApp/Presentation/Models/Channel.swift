//
//  Channel.swift
//  ChatApp
//
//  Created by Valeria Muldt on 27.10.2021.
//

import Foundation

struct Channel {

    // MARK: - Public Properties
    
    let identifier: String
    let name: String
    let lastMessage: String?
    let lastActivity: Date?
}

// MARK: -

extension Channel {
    var toDict: [String: Any] {
        return ["identifier": identifier,
                "name": name,
                "lastMessage": lastMessage ?? "",
                "lastActivity": lastActivity ?? Date()]
    }
}
