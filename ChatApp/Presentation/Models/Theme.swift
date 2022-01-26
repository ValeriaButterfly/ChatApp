//
//  Theme.swift
//  ChatApp
//
//  Created by Valeria Muldt on 21.10.2021.
//

import Foundation

enum ThemeType: String {
    case classic
    case day
    case night
}

// MARK: -

struct Theme {

    // MARK: - Public Properties

    private var appearance: UIUserInterfaceStyle
    private var color: UIColor
    private var textColor: UIColor
    private var incomingMessageColor: UIColor
    private var outcomingMessageColor: UIColor
    private var inputMessageViewColor: UIColor

    // MARK: - Private Properties

    private let type: ThemeType

    init(type: ThemeType) {
        self.type = type

        switch type {
        case .classic:
            self.appearance = .light
            self.color = .white
            self.textColor = .black
            self.incomingMessageColor = .lightGray
            self.outcomingMessageColor = .green
            self.inputMessageViewColor = .lightGray
        case .day:
            self.appearance = .light
            self.color = .white
            self.textColor = .black
            self.incomingMessageColor = .lightGray
            self.outcomingMessageColor = .blue
            self.inputMessageViewColor = .lightGray
        case .night:
            self.appearance = .dark
            self.color = .black
            self.textColor = .white
            self.incomingMessageColor = .lightGray
            self.outcomingMessageColor = .darkGray
            self.inputMessageViewColor = .darkGray
        }
    }

    func configure() {
        Constants.incomingMessageColor = self.incomingMessageColor
        Constants.outcomingMessageColoe = self.outcomingMessageColor
        
        if #available(iOS 13.0, *) {
            UIApplication.shared.windows.forEach { window in
                window.overrideUserInterfaceStyle = self.appearance
            }
        } else {
            UIApplication.shared.windows.forEach { window in
                window.backgroundColor = self.color
            }
            UILabel.appearance().textColor = self.textColor
        }
    }
}
