//
//  TrainingSegue.swift
//  ChatApp
//
//  Created by Valeria Muldt on 02.12.2021.
//

import UIKit

class TrainingSegue: UIStoryboardSegue {

    // MARK: - Lifecycle

    override func perform() {
        destination.transitioningDelegate = self
        super.perform()
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension TrainingSegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TrainingTransition()
    }
}
