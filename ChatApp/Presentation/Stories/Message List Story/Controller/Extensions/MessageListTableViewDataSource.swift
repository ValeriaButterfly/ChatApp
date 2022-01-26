//
//  MessageListTableViewDataSource.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.12.2021.
//

import UIKit
import CoreData

class MessageListTableViewDataSource: NSObject, UITableViewDataSource {

    // MARK: - Private Properties

    private let fetchedResultsController: NSFetchedResultsController<DBMessage>
    private let model: MessageList

    private let cellIdentifier = MessageTableViewCell.name

    // MARK: - Initializers

    init(fetchedResultsController: NSFetchedResultsController<DBMessage>, model: MessageList) {
        self.fetchedResultsController = fetchedResultsController
        self.model = model
        try? fetchedResultsController.performFetch()
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.name, for: indexPath) as? MessageTableViewCell else {
            fatalError("По индексу \(indexPath) ячейка с типом \(MessageTableViewCell.name) не найдена")
        }

        let message = model.getMessageForCell(self.fetchedResultsController.object(at: indexPath))
        cell.configure(with: message)
        
        model.loadImageForMessage(message.text ?? "") { image in
            message.image = image
            DispatchQueue.main.async {
                cell.configure(with: message)
            }
        }

        return cell
    }
}
