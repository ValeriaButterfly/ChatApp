//
//  ChannelList.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.12.2021.
//

import Foundation

class ChannelList {

    // MARK: - Private Properties

    private let channelService: ChannelServiceProtocol = ChannelService.shared
    private let databaseDomainMappingService: DatabaseDomainMappingServiceProtocol = DatabaseDomainMappingService()

    // MARK: - Public Methods

    func createChannel(with name: String) {
        self.channelService.send(channel: Channel(identifier: "",
                                                  name: name,
                                                  lastMessage: nil,
                                                  lastActivity: nil))
    }

    func getChannel(_ channel: DBChannel) -> Channel {
        databaseDomainMappingService.map(dbChannel: channel)
    }

    func getChannelForCell(_ channel: DBChannel) -> ChannelCell {
        databaseDomainMappingService.map(channel)
    }

    func delete(_ channel: Channel) {
        channelService.delete(channel: channel)
    }
}
