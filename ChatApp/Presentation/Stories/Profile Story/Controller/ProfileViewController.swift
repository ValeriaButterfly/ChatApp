//
//  ViewController.swift
//  ChatApp
//
//  Created by Valeria Muldt on 21.09.2021.
//

import AVFoundation
import UIKit

class ProfileViewController: UIViewController {

    private enum ImageSource {
        case photoLibrary
        case camera
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var iconImageView: UIImageView!

    @IBOutlet private weak var nameTitleTextField: UITextField!

    @IBOutlet private weak var specialityTitleTextField: UITextField!
    @IBOutlet private weak var livingPlaceTitleTextField: UITextField!

    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var changeImageButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Public Properties

//    var user: User?

    weak var delegate: ProfileViewControllerDelegate?

    // MARK: - Private properties

    private var model: Profile = Profile()

    private var imagePicker: UIImagePickerController!

    private var timer: Timer?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        LogService.shared.info(message: #function)

        model.configure()
        prepareView()

        print(editButton.frame)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        LogService.shared.info(message: #function)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogService.shared.info(message: #function)

        // Frame разный потому, что viewDidLoad вызывается до того, как будут определены
        // размеры и границы, он берет именно данные из .xib (.nib) файла и размер устройства
        // пользователя может быть отличным от того, на котором мы верстаем.
        // Во viewDidAppear уже показываются именно те значения view, которые видно на экране.
        print(editButton.frame)
        animate(editButton)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        LogService.shared.info(message: #function)

        iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
        cancelButton.layer.cornerRadius = 14.0
        saveButton.layer.cornerRadius = 14.0
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        LogService.shared.info(message: #function)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogService.shared.info(message: #function)
        setModeStyle(isEditing: false)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LogService.shared.info(message: #function)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        showFloatingAnimation(in: location)
    }

    // MARK: - IBAction

    @IBAction private func editAction(_ sender: Any) {
        setModeStyle(isEditing: true)
        nameTitleTextField.becomeFirstResponder()
    }

    @IBAction private func changeImageAction(_ sender: Any) {
        takeNewImage()
    }

    @IBAction private func cancelAction(_ sender: Any) {
        setModeStyle(isEditing: false)
    }

    @IBAction private func saveAction(_ sender: Any) {
        activityIndicator.startAnimating()
        reloadAvialability(isEnabled: false)

        model.saveUser { [weak self] error in
            if error == nil {
                self?.setModeStyle(isEditing: false)
                self?.simpleAlert(with: "Данные сохранены")
            } else {
                self?.simpleAlert(with: "Ошибка", message: "Не удалось сохранить данные")
            }
            self?.activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Private methods

    private func prepareView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        view.addGestureRecognizer(tap)

        activityIndicator.hidesWhenStopped = true

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = ""

        guard let navigationBar = navigationController?.navigationBar else { return }

        let titleFrame = CGRect(x: 16.0, y: 0.0, width: navigationBar.frame.width, height: navigationBar.frame.height)
        let titleLabel = UILabel(frame: titleFrame)
        titleLabel.font = .boldSystemFont(ofSize: 26)
        titleLabel.text = "My Profile"

        navigationBar.addSubview(titleLabel)

        setModeStyle(isEditing: false)

        reloadData()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showAnimation(_:)))
        view.addGestureRecognizer(tapGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(showLongAnimation(_:)))
        longPressGesture.minimumPressDuration = 0.2
        view.addGestureRecognizer(longPressGesture)
    }

    @objc private func showAnimation(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        showFloatingAnimation(in: location)
    }

    @objc private func showLongAnimation(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self.view)
        switch sender.state {
        case .began:
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true, block: { _ in
                    self.showFloatingAnimation(in: location)
                })
            }
        case .cancelled, .ended:
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
        default: break
        }
    }

    @objc private func showFloatingAnimation(in location: CGPoint) {
        let tinkoffView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 30.0, height: 30.0))
        tinkoffView.image = #imageLiteral(resourceName: "tinkoffIcon")
        view.addSubview(tinkoffView)
        tinkoffView.center = location

        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseOut) {
            tinkoffView.center = CGPoint(x: tinkoffView.center.x, y: tinkoffView.center.y - 100.0)
            tinkoffView.alpha = 0.0
        } completion: { _ in
            tinkoffView.removeFromSuperview()
        }
    }

    private func animate(_ view: UIView) {
        let rotationAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.transform))
        rotationAnimation.valueFunction = CAValueFunction(name: CAValueFunctionName.rotateZ)
        rotationAnimation.values = [0, -CGFloat(Double.pi / 10), 0, CGFloat(Double.pi / 10), 0]
        rotationAnimation.keyTimes = [0, 0.25, 0.5, 0.75, 1]

        let position = view.layer.position
        let positionAnimation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        positionAnimation.values = [position,
                                    CGPoint(x: position.x, y: position.y - 5),
                                    CGPoint(x: position.x, y: position.y + 5),
                                    CGPoint(x: position.x - 5, y: position.y),
                                    CGPoint(x: position.x + 5, y: position.y),
                                    position]
        positionAnimation.keyTimes = [0, 0.2, 0.4, 0.6, 0.8, 1.0]

        let group = CAAnimationGroup()
        group.duration = 0.3
        group.repeatCount = .infinity
        group.animations = [rotationAnimation, positionAnimation]

        view.layer.add(group, forKey: nil)
    }

    private func stopAnimation(_ view: UIView) {
        UIView.animate(withDuration: 10.0) {
            view.layer.removeAllAnimations()
        }
    }

    private func setModeStyle(isEditing: Bool) {
        nameTitleTextField.isEnabled = isEditing
        specialityTitleTextField.isEnabled = isEditing
        livingPlaceTitleTextField.isEnabled = isEditing

        cancelButton.isHidden = !isEditing
        changeImageButton.isHidden = !isEditing
        saveButton.isHidden = !isEditing

        editButton.isEnabled = !isEditing

        isEditing ? stopAnimation(editButton) : animate(editButton)

        reloadAvialability(isEnabled: false)
    }

    private func reloadAvialability(isEnabled: Bool) {
        saveButton.isEnabled = isEnabled
    }

    private func reloadData() {
        guard let user = model.user else { return }

        iconImageView.image = UIImage(data: user.image) ?? #imageLiteral(resourceName: "logoPlaceholderIcon")
        nameTitleTextField.text = user.fullName
        specialityTitleTextField.text = user.speciality
        livingPlaceTitleTextField.text = user.livingPlace
    }

    @objc private  func closeView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.controllerDidSelectClose()
    }

    @objc private func tapImageAction(_ sender: Any) {
        print("Выбери изображение профиля")
        takeNewImage()
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              self.view.frame.origin.y == 0 else { return }
        self.view.frame.origin.y -= keyboardSize.height
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        guard self.view.frame.origin.y != 0 else { return }
        self.view.frame.origin.y = 0
    }

    @objc private func hideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }

    private func takeNewImage() {
        takeNewImage { [weak self] _ in
            self?.selectImage(from: .photoLibrary)
        } cameraAction: { [weak self] in
            self?.selectImage(from: .camera)
        } loadAction: { [weak self] _ in
            self?.model.getImageList(completion: { result in
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

    private func selectImage(from source: ImageSource) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = ["public.image"]

        switch source {
        case .camera: imagePicker.sourceType = .camera
        case .photoLibrary: imagePicker.sourceType = .photoLibrary
        }

        present(imagePicker, animated: true, completion: nil)
    }

    private func showImageList(for imageList: [Image]) {
        let imageListVC = ImageListViewController(nibName: ImageListViewController.name, bundle: nil)
        imageListVC.delegate = self
        
        imageListVC.imageList = imageList

        present(imageListVC, animated: true, completion: nil)
    }

    private func setIconImage(_ selectedImage: UIImage) {
        iconImageView.image = selectedImage
        model.user?.image = selectedImage.pngData() ?? Data()
        reloadAvialability(isEnabled: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)

        guard let selectedImage = info[.editedImage] as? UIImage else { return }

        setIconImage(selectedImage)
    }
}

// MARK: - UINavigationControllerDelegate

extension ProfileViewController: UINavigationControllerDelegate { }

// MARK: - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        reloadAvialability(isEnabled: !text.isEmpty)

        switch textField {
        case nameTitleTextField: model.user?.fullName = textField.text ?? ""
        case specialityTitleTextField: model.user?.speciality = textField.text ?? ""
        case livingPlaceTitleTextField: model.user?.livingPlace = textField.text ?? ""
        default: break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTitleTextField: specialityTitleTextField.becomeFirstResponder()
        case specialityTitleTextField: livingPlaceTitleTextField.becomeFirstResponder()
        case livingPlaceTitleTextField: view.endEditing(true)
        default: break
        }

        return false
    }
}

// MARK: - ImageListDelegate

extension ProfileViewController: ImageListDelegate {

    func viewDidChooseImage(_ image: UIImage, url: String) {
        setIconImage(image)
    }
}
