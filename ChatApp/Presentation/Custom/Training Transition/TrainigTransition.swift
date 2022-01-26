//
//  TrainigTransition.swift
//  ChatApp
//
//  Created by Valeria Muldt on 02.12.2021.
//

import Foundation

class TrainingTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView
        let containerCenter = containerView.center

        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) as? ThemesViewController,
              let toView = transitionContext.view(forKey: .to) else { return }

        toVC.view.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        toVC.view.center = containerCenter

        containerView.addSubview(toView)

        toView.frame = fromVC.view.frame
        toView.layoutIfNeeded()

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut) {
            toVC.view.transform = CGAffineTransform.identity
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
}
