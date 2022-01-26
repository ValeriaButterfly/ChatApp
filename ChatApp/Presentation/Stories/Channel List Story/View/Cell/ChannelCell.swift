//
//  ChannelCell.swift
//  ChatApp
//
//  Created by Valeria Muldt on 18.11.2021.
//

import Foundation

protocol ChannelCellConfigurationProtocol: AnyObject {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
}

// MARK: -

class ChannelCell: ChannelCellConfigurationProtocol {

    // MARK: - Properties

    var name: String?
    var message: String?
    var date: Date?

    // MARK: - Initializers

    init(name: String?, message: String?, date: Date?) {
        self.name = name
        self.message = message
        self.date = date
    }
}
