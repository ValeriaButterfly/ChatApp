//
//  DatabaseDomainMappingService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.12.2021.
//

import Foundation

protocol DatabaseDomainMappingServiceProtocol: AnyObject {

    // MARK: - Methods

    func map(dbChannel: DBChannel) -> Channel
    func map(_ channel: DBChannel) -> ChannelCell

    func map(dbMessage: DBMessage) -> Message
    func map(_ message: DBMessage, user: User) -> MessageCell
}

class DatabaseDomainMappingService: DatabaseDomainMappingServiceProtocol {

    // MARK: - Public Methods

    @discardableResult
    func map(dbChannel: DBChannel) -> Channel {
        Channel(identifier: dbChannel.identifier,
                name: dbChannel.name,
                lastMessage: dbChannel.lastMessage,
                lastActivity: dbChannel.lastActivity)
    }

    func map(_ channel: DBChannel) -> ChannelCell {
        return ChannelCell(name: channel.name,
                           message: channel.lastMessage,
                           date: channel.lastActivity)
    }

    func map(dbMessage: DBMessage) -> Message {
        Message(content: dbMessage.content,
                created: dbMessage.created,
                senderId: dbMessage.senderId,
                senderName: dbMessage.senderName)
    }

    func map(_ message: DBMessage, user: User) -> MessageCell {
        let name = message.senderId == user.identifier ? nil : message.senderName.isEmpty ? "NoName" : message.senderName
        return MessageCell(text: message.content,
                                senderName: name,
                                isIncoming: message.senderId != user.identifier)
    }
}
