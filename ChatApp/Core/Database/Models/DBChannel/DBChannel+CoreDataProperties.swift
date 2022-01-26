//
//  DBChannel+CoreDataProperties.swift
//  ChatApp
//
//  Created by Valeria Muldt on 04.11.2021.
//
//

import Foundation
import CoreData

extension DBChannel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBChannel> {
        return NSFetchRequest<DBChannel>(entityName: "DBChannel")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messageList: NSSet?

}

// MARK: Generated accessors for messageList
extension DBChannel {

    @objc(addMessageListObject:)
    @NSManaged public func addToMessageList(_ value: DBMessage)

    @objc(removeMessageListObject:)
    @NSManaged public func removeFromMessageList(_ value: DBMessage)

    @objc(addMessageList:)
    @NSManaged public func addToMessageList(_ values: NSSet)

    @objc(removeMessageList:)
    @NSManaged public func removeFromMessageList(_ values: NSSet)

}
