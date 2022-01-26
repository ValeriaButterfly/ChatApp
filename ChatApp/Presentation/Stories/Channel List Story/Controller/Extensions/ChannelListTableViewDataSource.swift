//
//  ChannelListTableViewDataSource.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.12.2021.
//

import UIKit
import CoreData

class ChannelListTableViewDataSource: NSObject, UITableViewDataSource {

    // MARK: - Private Properties

    private let fetchedResultsController: NSFetchedResultsController<DBChannel>
    private let model: ChannelList

    private let cellIdentifier = ChannelTableViewCell.name

    // MARK: - Initializers

    init(fetchedResultsController: NSFetchedResultsController<DBChannel>, model: ChannelList) {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ChannelTableViewCell else {
            fatalError("По индексу \(indexPath) ячейка с типом \(cellIdentifier) не найдена")
        }

        let channel = self.fetchedResultsController.object(at: indexPath)

        cell.configure(with: model.getChannelForCell(channel))

        return cell
    }
}
