//
//  MessageListViewController.swift
//  ChatApp
//
//  Created by Valeria Muldt on 06.10.2021.
//

import UIKit
import CoreData

class MessageListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var informationLabel: UILabel!

    @IBOutlet private weak var inputTextViewContainer: UIView!
    @IBOutlet private weak var inputTextView: UITextView!
    @IBOutlet private weak var inputContainerViewBottomConstraint: NSLayoutConstraint!

    // MARK: - Public Properties

    var channel: Channel?

    // MARK: - Private properties

    private let model = MessageList()

    private var fetchedResultsController: NSFetchedResultsController<DBMessage>?

    private lazy var tableViewDataSource: UITableViewDataSource = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        let context = appDelegate.database.mainQueueContext

        let request: NSFetchRequest<DBMessage> = DBMessage.fetchRequest()

        let sort = NSSortDescriptor(key: "created", ascending: true)
        request.sortDescriptors = [sort]

        request.fetchBatchSize = 15

        request.predicate = NSPredicate(format: "channel.identifier == %@", channel?.identifier ?? "")

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
        
        fetchedResultsController.delegate = self

        return MessageListTableViewDataSource(fetchedResultsController: fetchedResultsController, model: model)
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        model.channel = channel
        model.registerObserver()
        prepareView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        inputTextView.layer.cornerRadius = 16.0
    }

    @IBAction func sendMessageAction(_ sender: Any) {
        guard inputTextView.text != "Your message here..." && !inputTextView.text.isEmpty else { return }

        model.send(inputTextView.text) { [weak self] error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.simpleAlert(with: "Ошибка", message: "Чтобы отправить сообщение, заполните имя пользователя в профиле.")
                } else {
                    self?.reloadVisibility()
                }
            }
        }

        inputTextView.text = ""
    }

    @IBAction func sendImageAction(_ sender: Any) {
        takeNewImage { [weak self] _ in
            self?.simpleAlert(with: "В разработке.", message: "Данный функционал появится в будущем.")
        } cameraAction: { [weak self] in
            self?.simpleAlert(with: "В разработке.", message: "Данный функционал появится в будущем.")
        } loadAction: { [weak self] _ in
            self?.model.getImageListForSend(completion: { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageList): self?.showImageList(for: imageList)
                    case .failure(let error):
                        self?.simpleAlert(with: "Ошибка.", message: "Не удалось загрузить фотографии. \(error.localizedDescription)")
                    }
                }
            })
        }

    }

    // MARK: - Private methods

    private func prepareView() {
        tabBarController?.tabBar.isHidden = true

        tableView.dataSource = self.tableViewDataSource

        tableView.register(UINib(nibName: MessageTableViewCell.name, bundle: nil), forCellReuseIdentifier: MessageTableViewCell.name)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        reloadVisibility()
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

        inputContainerViewBottomConstraint.constant = keyboardSize.height
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        inputContainerViewBottomConstraint.constant = 0
    }

    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)

        if inputTextView.text.isEmpty {
            inputTextView.text = "Your message here..."
            inputTextView.textColor = #colorLiteral(red: 0.5371322036, green: 0.5369167924, blue: 0.5575823188, alpha: 1)
        }
    }

    private func reloadVisibility() {
        guard let results = fetchedResultsController?.fetchedObjects else { return }

        tableView.isHidden = results.isEmpty
        informationLabel.isHidden = !results.isEmpty
    }

    private func showImageList(for imageList: [Image]) {
        let imageListVC = ImageListViewController(nibName: ImageListViewController.name, bundle: nil)
        imageListVC.delegate = self

        imageListVC.imageList = imageList

        present(imageListVC, animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension MessageListViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.text == "Your message here..." else { return }
        textView.text = ""
        textView.textColor = .black
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension MessageListViewController: NSFetchedResultsControllerDelegate {

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

        reloadVisibility()
    }
}

// MARK: - ImageListDelegate

extension MessageListViewController: ImageListDelegate {

    func viewDidChooseImage(_ image: UIImage, url: String) {
        model.send(url) { [weak self] error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.simpleAlert(with: "Ошибка", message: "Чтобы отправить сообщение, заполните имя пользователя в профиле.")
                } else {
                    self?.reloadVisibility()
                }
            }
        }
    }
}
