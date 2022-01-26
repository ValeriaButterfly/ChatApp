//
//  NSObjectProtocol + Additions.swift
//  ChatApp
//
//  Created by Valeria Muldt on 01.10.2021.
//

import Foundation

extension NSObjectProtocol {

    // MARK: - Properties

    static var name: String { String(describing: self) }
}
