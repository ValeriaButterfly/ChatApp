//
//  UIViewController + Additions.swift
//  ChatApp
//
//  Created by Valeria Muldt on 30.09.2021.
//

import UIKit
import AVFoundation

extension UIViewController {
    
    func simpleAlert(with title: String? = nil, message: String? = nil, buttonTitle: String = "ОК") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)

        alertVC.addAction(action)

        present(alertVC, animated: true, completion: nil)
    }

    func settingsAlert(with title: String? = nil, message: String? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let openSettingsAction = UIAlertAction(title: "Настройки", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString),
                  UIApplication.shared.canOpenURL(url) else {
                self.simpleAlert(with: "Ошибка", message: "Не удалось открыть настройки.", buttonTitle: "ОК")
                return
            }

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertVC.addAction(openSettingsAction)
        alertVC.addAction(cancelAction)

        present(alertVC, animated: true, completion: nil)
    }

    func takeNewImage(libraryAction: @escaping ((UIAlertAction) -> Void),
                      cameraAction: @escaping (() -> Void),
                      loadAction: @escaping ((UIAlertAction) -> Void)) {
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let libraryAction = UIAlertAction(title: "Установить из галереи", style: .default, handler: libraryAction)
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                self?.simpleAlert(with: "Ошибка", message: "Камера не доступна.")
                return
            }
            guard AVCaptureDevice.authorizationStatus(for: .video) == .authorized else {
                self?.settingsAlert(with: "Доступ к камере запрещен", message: "Перейдите в настройки, чтобы снять ограничение.")
                return
            }
            cameraAction()
        }
        let loadAction = UIAlertAction(title: "Загрузить", style: .default, handler: loadAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertVC.addAction(libraryAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(loadAction)
        alertVC.addAction(cancelAction)

        self.present(alertVC, animated: true, completion: nil)
    }
}
