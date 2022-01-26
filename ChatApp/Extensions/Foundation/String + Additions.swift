//
//  String + Additions.swift
//  ChatApp
//
//  Created by Valeria Muldt on 06.10.2021.
//

import Foundation

extension String {

    // MARK: - Methods

    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        return dateFormatter.date(from: self)
    }
}
