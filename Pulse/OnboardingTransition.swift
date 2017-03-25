//
//  OnboardingTransition.swift
//  Pulse
//
//  Created by Design First Apps on 3/15/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class Onboarding: UIViewController {
    
}

class OnboardingTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: Double = 1.0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // Get references
        let containerView: UIView = transitionContext.containerView
        guard let fromVC: UIViewController = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC: UIViewController = transitionContext.viewController(forKey: .to) else { return }
        
        let backer: UIView = UIView(frame: fromVC.view.frame)
        backer.backgroundColor = fromVC.view.backgroundColor
        containerView.insertSubview(backer, belowSubview: fromVC.view)
        
        // Animate
        UIView.animateKeyframes(withDuration: self.duration, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.duration / 3, animations: {
                fromVC.view.alpha = 0.0
            })
            UIView.addKeyframe(withRelativeStartTime: self.duration / 3, relativeDuration: self.duration / 3, animations: {
                backer.backgroundColor = toVC.view.backgroundColor
            })
            UIView.addKeyframe(withRelativeStartTime: 0.66, relativeDuration: 0.0, animations: {
                toVC.view.alpha = 0.0
                containerView.addSubview(toVC.view)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.665, relativeDuration: self.duration / 3, animations: {
                toVC.view.alpha = 1.0
            })
        }) { (finished) in
            // Clean up transition
            fromVC.view.alpha = 1.0
            backer.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func hideViews(view: UIView, _ hidden: Bool) {
        for subview in view.subviews {
            subview.alpha = hidden ? 0.0 : 1.0
        }
    }
}
