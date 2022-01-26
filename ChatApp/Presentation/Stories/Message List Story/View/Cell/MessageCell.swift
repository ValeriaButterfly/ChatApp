//
//  MessageCell.swift
//  ChatApp
//
//  Created by Valeria Muldt on 18.11.2021.
//

import Foundation

protocol MessageCellConfigurationProtocol: AnyObject {
    var text: String? { get set }
    var senderName: String? { get set }
    var isIncoming: Bool { get set }
}

// MARK: -

class MessageCell: MessageCellConfigurationProtocol {

    // MARK: - Public Properties

    var text: String?
    var senderName: String?
    var isIncoming: Bool
    var image: UIImage?

    // MARK: - Initializers

    init(text: String?, senderName: String?, isIncoming: Bool) {
        self.text = text
        self.senderName = senderName
        self.isIncoming = isIncoming
    }
}
