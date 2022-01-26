//
//  Message.swift
//  ChatApp
//
//  Created by Valeria Muldt on 27.10.2021.
//

import Foundation
import Firebase

struct Message {

    // MARK: - Public Properties
    
    let content: String
    let created: Date
    let senderId: String
    let senderName: String
}

// MARK: -

extension Message {
    var toDict: [String: Any] {
        return ["content": content,
                "created": Timestamp(date: created),
                "senderID": senderId,
                "senderName": senderName]
    }
}
