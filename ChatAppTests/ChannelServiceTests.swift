//
//  ChannelServiceTests.swift
//  ChatAppTests
//
//  Created by Valeria Muldt on 13.12.2021.
//

@testable import ChatApp
import XCTest

class DatabaseDomainMappingServiceMock: DatabaseDomainMappingService { }

// MARK: -

class ChannelServiceTests: XCTestCase {

    // MARK: - Private Properties

    private var coreDataStack: DatabaseStackProtocol!
    private var channelService: ChannelServiceProtocol!
    private var databaseDomainMappingService: DatabaseDomainMappingServiceProtocol!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()

        coreDataStack = DatabaseStack()
        channelService = ChannelService.shared
        channelService.configure(with: coreDataStack)

        databaseDomainMappingService = DatabaseDomainMappingServiceMock()
    }

    override func tearDown() {
        super.tearDown()

        coreDataStack = nil
        channelService = nil

        databaseDomainMappingService = nil
    }

    // MARK: - Methods

    func testSendChannel() {
        expectation(forNotification: .NSManagedObjectContextDidSave, object: coreDataStack.mainQueueContext) { _ in
            return true
        }

        let channel = Channel(identifier: "123", name: "Something", lastMessage: nil, lastActivity: nil)

        channelService.add(channel: channel, to: coreDataStack) { dbChannel in
            XCTAssertNotNil(dbChannel)
        }

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testMapFromDBtoDomain() {
        guard let dbChannelList = channelService.getChannelList(from: coreDataStack),
              !dbChannelList.isEmpty else { return }

        let dbChannel = dbChannelList.first
        XCTAssertNotNil(dbChannel)

        guard let dbChannel = dbChannel else { return XCTAssert(dbChannel == nil) }
        let channel = databaseDomainMappingService.map(dbChannel: dbChannel)

        XCTAssertTrue(dbChannel.identifier == channel.identifier)
        XCTAssertTrue(dbChannel.name == channel.name)
        XCTAssertTrue(dbChannel.lastActivity == channel.lastActivity)
        XCTAssertTrue(dbChannel.lastMessage == channel.lastMessage)
    }

}
