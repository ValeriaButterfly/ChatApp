//
//  ChannelService.swift
//  ChatApp
//
//  Created by Valeria Muldt on 27.10.2021.
//

import Foundation
import Firebase
import CoreData

protocol ChannelServiceProtocol: AnyObject {

    // MARK: - Methods

    func configure(with coreData: DatabaseStackProtocol)

    func send(channel: Channel)
    func add(channel: Channel, to coreData: DatabaseStackProtocol, completion: @escaping ((DBChannel?) -> Void))
    func getChannelList(from coreData: DatabaseStackProtocol) -> [DBChannel]?
    func delete(channel: Channel)
}

// MARK: -

class ChannelService: ChannelServiceProtocol {

    static let shared: ChannelServiceProtocol = ChannelService()

    // MARK: - Private Properties

    private lazy var db = Firestore.firestore()
    private lazy var reference = db.collection("channels")

    private let logService = LogService.shared

    // MARK: - Initializers

    private init() { }

    // MARK: - Public Methods

    func configure(with coreData: DatabaseStackProtocol) {
        reference.addSnapshotListener { snapshot, error in
            guard error == nil, let snapshot = snapshot else { return }
            let documentsIdList = snapshot.documents.map { $0.documentID }

            snapshot.documents.forEach {
                let lastActivity = $0["lastActivity"] as? Timestamp
                let channel = Channel(identifier: $0.documentID,
                                      name: $0["name"] as? String ?? "",
                                      lastMessage: $0["lastMessage"] as? String ?? "",
                                      lastActivity: lastActivity?.dateValue())

                self.add(channel: channel, to: coreData) { _ in }
            }

            self.deleteFromDB(documentsIdList)

        }
    }

    func add(channel: Channel, to coreData: DatabaseStackProtocol, completion: @escaping ((DBChannel?) -> Void)) {
        coreData.performInMainQueueContextAndSave { context in
            let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()

            do {
                let dbChannelList = try context.fetch(fetchRequest)
                var dbChannel = dbChannelList.first(where: { $0.identifier == channel.identifier })

                if dbChannel == nil {
                    dbChannel = NSEntityDescription.insertNewObject(forEntityName: "DBChannel", into: context) as? DBChannel
                }

                guard let dbChannel = dbChannel else { return completion(nil) }

                dbChannel.identifier = channel.identifier
                dbChannel.name = channel.name
                dbChannel.lastMessage = channel.lastMessage
                dbChannel.lastActivity = channel.lastActivity

                completion(dbChannel)
            } catch {
                self.logService.error(message: "DatabaseService - \(#function) - \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    func getChannelList(from coreData: DatabaseStackProtocol) -> [DBChannel]? {
        let fetchRequest: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()

        do {
            let dbChannelList = try coreData.mainQueueContext.fetch(fetchRequest)
            return dbChannelList
        } catch {
            self.logService.error(message: "DatabaseService - \(#function) - \(error.localizedDescription)")
        }

        return nil
    }

    func send(channel: Channel) {
        reference.addDocument(data: channel.toDict)
    }

    func delete(channel: Channel) {
        reference.getDocuments { snapshot, error in
            guard error == nil, let snapshot = snapshot else { return }
            snapshot.documents.forEach {
                if $0.documentID == channel.identifier {
                    $0.reference.delete()
                }
            }
        }
    }

    // MARK: - Private Methods

    private func deleteFromDB(_ idList: [String]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let coreData = appDelegate.database
        coreData.performInMainQueueContextAndSave { context in
            let request: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()
            let dbChannelList = try? context.fetch(request)

            guard let idForDeletion = dbChannelList?.map({ $0.identifier }).difference(from: idList) else { return }
            idForDeletion.forEach { id in
                guard let dbChannel = dbChannelList?.first(where: { $0.identifier == id }) else { return }

                dbChannel.messageList?.forEach {
                    guard let message = ($0 as? DBMessage) else { return }
                    context.delete(message)
                }

                context.delete(dbChannel)
            }
        }
    }
}
