//
//  DatabaseStack.swift
//  ChatApp
//
//  Created by Valeria Muldt on 04.11.2021.
//

import Foundation
import CoreData

protocol DatabaseStackProtocol {

    // MARK: - Properties

    var mainQueueContext: NSManagedObjectContext { get set }

    // MARK: - Methods

    func performInMainQueueContext(_ block: (NSManagedObjectContext) -> Void)
    func performInMainQueueContextAndSave(_ block: (NSManagedObjectContext) -> Void)
}

// MARK: -

class DatabaseStack: DatabaseStackProtocol {

    // MARK: - Private Properties

    private var storeUrl: URL = {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).last!
        return documentsUrl.appendingPathComponent("ChatApp.sqlite")
    }()

    private let dataModelName = "ChatApp"
    private let dataModelExtension = "momd"

    private(set) lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: self.dataModelName,
                                       withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()

    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)

        do {
            // TODO: it would be better to move adding store operation off the main queue
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                              configurationName: nil,
                                                              at: self.storeUrl,
                                                              options: nil)
        } catch {
            assertionFailure("Error adding CoreData store: \(error)")
        }

        return persistentStoreCoordinator
    }()

    lazy var mainQueueContext: NSManagedObjectContext = {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        return managedObjectContext
    }()

    private let logService = LogService.shared

    // MARK: - Public Methods

    func performInMainQueueContext(_ block: (NSManagedObjectContext) -> Void) {
        let context = self.mainQueueContext
        context.performAndWait {
            block(context)
        }
    }

    func performInMainQueueContextAndSave(_ block: (NSManagedObjectContext) -> Void) {
        let context = self.mainQueueContext
        context.performAndWait {
            block(context)
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    assertionFailure("Error saving data: \(error)")
                }
            }
        }
    }
}
