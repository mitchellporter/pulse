//
//  NoAnimationTransition.swift
//  Pulse
//
//  Created by Design First Apps on 3/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NoAnimationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: Double = 0.05
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC: UIViewController = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(toVC.view)
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}
