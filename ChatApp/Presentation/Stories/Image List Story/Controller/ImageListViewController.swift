//
//  ImageListViewController.swift
//  ChatApp
//
//  Created by Valeria Muldt on 23.11.2021.
//

import UIKit

class ImageListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Public Properties

    weak var delegate: ImageListDelegate?

    var imageList: [Image] = []

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    // MARK: - Private Methods

    private func prepareView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: ImageCollectionViewCell.name, bundle: nil), forCellWithReuseIdentifier: ImageCollectionViewCell.name)

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
}

// MARK: - UICollectionViewDataSource

extension ImageListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.name, for: indexPath) as? ImageCollectionViewCell else {
            fatalError("Не удалось найти ячейку типа \(ImageCollectionViewCell.name) по индексу \(indexPath)")
        }

        networkService.sendRequestForImage(url: imageList[indexPath.row].previewUrl) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let data):
                    self?.imageList[indexPath.row].data = data
                    cell.configure(with: ImageCell(data: data))
                case .failure: cell.configure(with: ImageCell(data: nil))
                }
            }
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ImageListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = imageList[indexPath.row]
        activityIndicator.startAnimating()
        networkService.sendRequestForImage(url: element.webformatUrl) { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success(let data):
                    self?.delegate?.viewDidChooseImage(UIImage(data: data) ?? #imageLiteral(resourceName: "imagePlaceholder"), url: element.webformatUrl)
                    self?.dismiss(animated: true, completion: nil)
                case .failure:
                    self?.simpleAlert(with: "Ошибка.", message: "Не удалось выбрать фото.")
                }
            }
        }

    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ImageListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (UIScreen.main.bounds.size.width - 40) / 3, height: ((UIScreen.main.bounds.size.width - 40) / 3))
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10.0
    }
}
