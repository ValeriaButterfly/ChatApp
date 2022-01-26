//
//  MessageService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 28.10.2021.
//

import Foundation
import Firebase
import CoreData

protocol MessageServiceProtocol: AnyObject {

    // MARK: - Methods

    func configure(with database: DatabaseStackProtocol)
    
    func send(message: Message)
}

// MARK: -

class MessageService: MessageServiceProtocol {

    // MARK: - Private Properties

    private lazy var db = Firestore.firestore()
    private lazy var reference: CollectionReference = {
        guard let channelIdentifier = channel?.identifier else { fatalError() }
        return db.collection("channels").document(channelIdentifier).collection("messages")
    }()

    private var channel: Channel?

    private let logService = LogService.shared

    // MARK: - Initializers

    init(for channel: Channel?) {
        self.channel = channel
    }

    // MARK: - Public Methods

    func configure(with database: DatabaseStackProtocol) {
        reference.addSnapshotListener { snapshot, error in
            guard error == nil,
                  let snapshot = snapshot else { return }

            var messageList = [Message]()
            snapshot.documents.forEach {
                let created = $0["created"] as? Timestamp
                let message = Message(content: $0["content"] as? String ?? "",
                                      created: created?.dateValue() ?? Date(),
                                      senderId: $0["senderID"] as? String ?? "",
                                      senderName: $0["senderName"] as? String ?? "")
                messageList.append(message)
            }

            self.saveMessageListToDatabase(messageList, to: database)
        }
    }

    func saveMessageListToDatabase(_ messageList: [Message], to database: DatabaseStackProtocol) {
        guard let channel = channel else { return }
        let coreData = database

        messageList.forEach { message in
            coreData.performInMainQueueContextAndSave { context in
                let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
                context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

                do {
                    let dbChannel: DBChannel? = try context.fetch(fetchRequest).first { $0.identifier == channel.identifier }

                    let dbMessage = DBMessage(context: context)

                    dbMessage.content = message.content
                    dbMessage.created = message.created
                    dbMessage.senderId = message.senderId
                    dbMessage.senderName = message.senderName

                    dbChannel?.addToMessageList(dbMessage)
                } catch {
                    self.logService.error(message: "DatabaseService - \(#function) - \(error.localizedDescription)")
                }
            }
        }
    }

    func send(message: Message) {
        reference.addDocument(data: message.toDict)
    }
}
