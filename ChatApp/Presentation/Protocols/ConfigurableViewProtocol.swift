//
//  ConfigurableViewProtocol.swift
//  ChatApp
//
//  Created by Valeria Muldt on 18.11.2021.
//

import Foundation

protocol ConfigurableViewProtocol {
     associatedtype ConfigurationModel

    // MARK: - Methods

     func configure(with model: ConfigurationModel)
 }
