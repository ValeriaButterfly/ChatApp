//
//  MessageTableViewCell.swift
//  ChatApp
//
//  Created by Valeria Muldt on 07.10.2021.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var senderNameTitleLabel: UILabel!
    @IBOutlet private weak var textTitleLabel: UILabel!
    @IBOutlet private weak var picImageView: UIImageView!

    @IBOutlet private weak var leadingViewConstarint: NSLayoutConstraint!
    @IBOutlet private weak var traillingViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomViewConstraint: NSLayoutConstraint!

    // MARK: - Private Properties

    private let networkService: NetworkServiceProtocol = NetworkService()

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        bubbleView.layer.cornerRadius = 8.0
    }

    private func switchConstraints() {
        let leading = leadingViewConstarint.constant
        leadingViewConstarint.constant = traillingViewConstraint.constant
        traillingViewConstraint.constant = leading
    }

    private func hideImageView() {
        self.picImageView.isHidden = true
        self.bottomViewConstraint.constant = self.picImageView.frame.size.height
    }
}

// MARK: - ConfigurableView

extension MessageTableViewCell: ConfigurableViewProtocol {

    func configure(with model: MessageCell) {
        textTitleLabel.text = model.text
        senderNameTitleLabel.text = model.senderName
        senderNameTitleLabel.isHidden = model.senderName == nil

        if let image = model.image {
            self.picImageView.image = image
            self.picImageView.isHidden = false
            self.textTitleLabel.isHidden = true
            self.textTitleLabel.text = ""
            self.bottomViewConstraint.constant = 0
        } else {
            self.textTitleLabel.text = textTitleLabel.text ?? "" + " [не удалось загрузить вложение]."
            self.hideImageView()
        }

        switch model.isIncoming {
        case true:
            bubbleView.backgroundColor = Constants.incomingMessageColor

        case false:
            bubbleView.backgroundColor = Constants.outcomingMessageColoe
            switchConstraints()
        }
    }
}
