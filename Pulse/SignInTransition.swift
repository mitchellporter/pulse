//
//  SignInTransition.swift
//  Pulse
//
//  Created by Design First Apps on 4/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class SignInTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: Double = 0.5
    
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            self.present(transitionContext)
        } else {
            self.dismiss(transitionContext)
        }
    }
    
    private func present(_ context: UIViewControllerContextTransitioning) {
        let container: UIView = context.containerView
        guard let fromVC: HomeViewController = context.viewController(forKey: .from) as? HomeViewController else { return }
        guard let toVC: SignInViewController = context.viewController(forKey: .to) as? SignInViewController else { return }
        
        
        let fromFrame: CGRect = fromVC.view.frame
        toVC.view.frame = CGRect(x: fromFrame.origin.x, y: fromFrame.height, width: fromFrame.width, height: fromFrame.height)
        container.addSubview(toVC.view)
        
        
        let titleFrame: CGRect = toVC.titleLabel.frame
        let buttonFrame: CGRect = fromVC.signInButton.titleLabel!.superview!.convert(fromVC.signInButton.titleLabel!.frame, to: container)
        
        container.addSubview(toVC.titleLabel)
        toVC.titleLabel.frame = buttonFrame
        fromVC.signInButton.alpha = 0.0
        
        UIView.animate(withDuration: self.duration, animations: {
            
            toVC.titleLabel.frame = titleFrame
            
            fromVC.view.frame.origin.y -= fromFrame.height
            toVC.view.frame.origin.y -= fromFrame.height
            
        }) { _ in
            toVC.view.addSubview(toVC.titleLabel)
            toVC.titleLabel.translatesAutoresizingMaskIntoConstraints = true
            toVC.titleLabel.frame = titleFrame
            fromVC.signInButton.alpha = 1.0
            fromVC.view.frame = fromFrame
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func dismiss(_ context: UIViewControllerContextTransitioning) {
        let container: UIView = context.containerView
        guard let fromVC: SignInViewController = context.viewController(forKey: .from) as? SignInViewController else { return }
        guard let toVC: HomeViewController = context.viewController(forKey: .to) as? HomeViewController else { return }
        
        
        let fromFrame: CGRect = fromVC.view.frame
        container.insertSubview(toVC.view, belowSubview: fromVC.view)
        toVC.view.frame = fromFrame
        
        
        let titleFrame: CGRect = fromVC.titleLabel.frame
        let buttonFrame: CGRect = toVC.signInButton.titleLabel!.superview!.convert(toVC.signInButton.titleLabel!.frame, to: container)
        toVC.view.frame = CGRect(x: fromFrame.origin.x, y: -fromFrame.height, width: fromFrame.width, height: fromFrame.height)
        
        container.addSubview(fromVC.titleLabel)
        fromVC.titleLabel.frame = titleFrame
        toVC.signInButton.alpha = 0.0
        
        UIView.animate(withDuration: self.duration, animations: {
            
            fromVC.titleLabel.frame = buttonFrame
            
            fromVC.view.frame.origin.y += fromFrame.height
            toVC.view.frame.origin.y += fromFrame.height
            
        }) { _ in
            fromVC.view.addSubview(fromVC.titleLabel)
            fromVC.titleLabel.translatesAutoresizingMaskIntoConstraints = true
            fromVC.titleLabel.frame = titleFrame
            toVC.signInButton.alpha = 1.0
            fromVC.view.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
