//
//  ChannelListViewController.swift
//  ChatApp
//
//  Created by Valeria Muldt on 01.10.2021.
//

import UIKit
import CoreData

class ChannelListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Private properties

    private lazy var rightBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showChannelAddition(_:)))
    }()

    private var model: ChannelList = ChannelList()
    private var fetchedResultsController: NSFetchedResultsController<DBChannel>?

    private lazy var tableViewDataSource: UITableViewDataSource = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let context = appDelegate.database.mainQueueContext

        let request: NSFetchRequest<DBChannel> = DBChannel.fetchRequest()

        let sort = NSSortDescriptor(key: "lastActivity", ascending: false)
        request.sortDescriptors = [sort]

        request.fetchBatchSize = 15

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        fetchedResultsController.delegate = self

        return ChannelListTableViewDataSource(fetchedResultsController: fetchedResultsController, model: model)
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let themesVC = segue.destination as? ThemesViewController {
            themesVC.closure = { [weak self] theme in
                self?.logThemeChanging(selectedTheme: theme)
            }
        }
    }

    // MARK: - Private methods

    private func prepareView() {
        tableView.delegate = self
        tableView.dataSource = self.tableViewDataSource

        tableView.register(UINib(nibName: ChannelTableViewCell.name, bundle: nil), forCellReuseIdentifier: ChannelTableViewCell.name)

//        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc private func showChannelAddition(_ sender: Any) {
        channelCreationAlert()
    }

    func channelCreationAlert() {
        let alert = UIAlertController(title: "Создать канал", message: nil, preferredStyle: .alert)

        let createAction = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else { return }
            self.model.createChannel(with: name)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addTextField {
            $0.placeholder = "Название канала"
        }

        alert.addAction(createAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc private func showThemes(_ sender: Any) {
//        showThemes(isObjC: false)
    }

    private func showThemes(isObjC: Bool) {
        let themeListVC = ThemeListViewController(nibName: ThemeListViewController.name, bundle: nil)
        themeListVC.delegate = self

        let themesVC = ThemesViewController(nibName: ThemesViewController.name, bundle: nil)
        themesVC.closure = { [weak self] theme in
            self?.logThemeChanging(selectedTheme: theme)
            //            self?.changeTheme(selectedTheme: theme)
        }

        let newNavigationController = UINavigationController(rootViewController: isObjC ? themeListVC : themesVC)

        navigationController?.present(newNavigationController, animated: true, completion: nil)
    }

    private func logThemeChanging(selectedTheme: UIColor) {
        LogService.shared.info(message: "\(selectedTheme)")
    }

    private func changeTheme(selectedTheme: UIColor) {
        navigationController?.isNavigationBarHidden = true

        UINavigationBar.appearance().barTintColor = selectedTheme

        let textColor: UIColor = selectedTheme == .black ? .white : .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: textColor]

        UserDefaults.standard.setColor(color: selectedTheme, forKey: "barColor")
        UserDefaults.standard.setColor(color: textColor, forKey: "barTextColor")

        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - UITableViewDelegate

extension ChannelListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let fetchedRC = self.fetchedResultsController else { return }

        let channel = model.getChannel(fetchedRC.object(at: indexPath))

        let messageListVC = MessageListViewController(nibName: MessageListViewController.name, bundle: nil)
        messageListVC.channel = channel
        messageListVC.title = channel.name

        navigationController?.pushViewController(messageListVC, animated: true)
    }

    private func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let fetchedRC = self.fetchedResultsController else { return }
        switch editingStyle {
        case .delete:
            let channel = model.getChannel(fetchedRC.object(at: indexPath))
            model.delete(channel)
        default: break
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        89
    }
}

// MARK: - ThemesViewControllerDelegate

extension ChannelListViewController: ThemesViewControllerDelegate {
    func themesViewController(_ controller: ThemeListViewController, didSelectTheme selectedTheme: UIColor) {
        logThemeChanging(selectedTheme: selectedTheme)

        changeTheme(selectedTheme: selectedTheme)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ChannelListViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .move:
            guard let newIndexPath = newIndexPath, let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        @unknown default:
            fatalError()
        }
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
