//
//  ThemesViewController.swift
//  ChatApp
//
//  Created by Valeria Muldt on 14.10.2021.
//

import UIKit

class ThemesViewController: UIViewController {

    // MARK: - Public Properties

    var closure: ((UIColor) -> Void)?

    // MARK: - Private Properties

    private lazy var closeBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(closeView(_:)))
    }()

    private let themeService = ThemeService()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareView()
    }

    // MARK: - IBAction

    @IBAction func firstThemeAction(_ sender: Any) {
        themeService.save(.classic) { [weak self] error in
            guard error != nil else { return }
            self?.simpleAlert(with: "Ошибка", message: "Не удалось обновить тему")
        }
    }
    
    @IBAction func secondThemeAction(_ sender: Any) {
        themeService.save(.day) { [weak self] error in
            guard error != nil else { return }
            self?.simpleAlert(with: "Ошибка", message: "Не удалось обновить тему")
        }
    }

    @IBAction func thirdThemeAction(_ sender: Any) {
        themeService.save(.night) { [weak self] error in
            guard error != nil else { return }
            self?.simpleAlert(with: "Ошибка", message: "Не удалось обновить тему")
        }
    }

    // MARK: - Private methods

    private func prepareView() {
        tabBarController?.tabBar.isHidden = true
        
        navigationItem.rightBarButtonItem = closeBarButtonItem
    }

    @objc private func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
