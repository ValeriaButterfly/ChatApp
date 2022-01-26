//
//  UserDefaults + Additions.swift
//  ChatApp
//
//  Created by Valeria Muldt on 12.10.2021.
//

import UIKit

extension UserDefaults {

    // MARK: - Methods
    
    func colorForKey(key: String) -> UIColor? {
        var color: UIColor?
        if let colorData = data(forKey: key) {
            do {
                color = try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
            } catch {
                print(error.localizedDescription)
            }
        }
        return color
    }

    func setColor(color: UIColor?, forKey key: String) {
        var colorData: Data?
        if let color = color {
            do {
                colorData = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
            } catch {
                print(error.localizedDescription)
            }
        }
        set(colorData, forKey: key)
    }
}
