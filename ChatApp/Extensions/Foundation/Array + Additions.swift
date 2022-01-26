//
//  Array + Additions.swift
//  ChatApp
//
//  Created by Valeria Muldt on 28.11.2021.
//

import Foundation

extension Array where Element: Hashable {

    // MARK: - Public Methods

    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.subtracting(otherSet))
    }
}
