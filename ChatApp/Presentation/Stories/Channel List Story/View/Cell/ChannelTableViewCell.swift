//
//  ChannelTableViewCell.swift
//  ChatApp
//
//  Created by Valeria Muldt on 06.10.2021.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameTitleLabel: UILabel!
    @IBOutlet private weak var messageTitleLabel: UILabel!
    @IBOutlet private weak var timeTitleLabel: UILabel!

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }

    // MARK: - Private methods

    private func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = Calendar(identifier: .gregorian).isDate(Date(), inSameDayAs: date) ? "HH:mm" : "dd MMM"

        return dateFormatter.string(from: date)
    }
}

// MARK: - ConfigurableView

extension ChannelTableViewCell: ConfigurableViewProtocol {

    func configure(with model: ChannelCell) {
        avatarImageView.image = #imageLiteral(resourceName: "logoPlaceholderIcon")

        nameTitleLabel.text = model.name

        messageTitleLabel.text = model.message ?? "No messages yet"

        timeTitleLabel.text = formatDate(date: model.date ?? Date())
    }
}
