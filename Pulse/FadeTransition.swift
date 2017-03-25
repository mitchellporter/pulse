//
//  FadeTransition.swift
//  Pulse
//
//  Created by Design First Apps on 3/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class FadeTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: Double = 0.25
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView: UIView = transitionContext.containerView
        guard let toVC: UIViewController = transitionContext.viewController(forKey: .to) else { return }
        guard let fromVC: UIViewController = transitionContext.viewController(forKey: .from) else { return }
        
        toVC.view.alpha = 0.0
        
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.duration, animations: {
            
            toVC.view.alpha = 1.0
            
        }) { _ in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
