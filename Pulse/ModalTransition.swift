//
//  ModalTransition.swift
//  Pulse
//
//  Created by Design First Apps on 3/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class ModalTransition: AnimatedTransition, UIViewControllerAnimatedTransitioning {

    var duration: Double = 0.25
    
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.presenting = self.originVC is TaskViewController ? true : false
        
        if self.presenting {
            self.present(context: transitionContext)
        } else {
            self.dismiss(context: transitionContext)
        }
    }
    
    private func present(context: UIViewControllerContextTransitioning) {
        let containerView: UIView = context.containerView
        guard let toVC: UIViewController = context.viewController(forKey: .to) else { return }
        guard let fromVC: UIViewController = context.viewController(forKey: .from) else { return }
        
        let startFrame: CGRect = CGRect(x: 0, y: fromVC.view.frame.height, width: fromVC.view.frame.width, height: fromVC.view.frame.height)
        toVC.view.frame = startFrame
        containerView.addSubview(toVC.view)
        
        UIView.animate(withDuration: self.duration, animations: {
            
            toVC.view.frame = fromVC.view.frame
            
        }) { _ in
            
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func dismiss(context: UIViewControllerContextTransitioning) {
        let containerView: UIView = context.containerView
        guard let toVC: UIViewController = context.viewController(forKey: .to) else { return }
        guard let fromVC: UIViewController = context.viewController(forKey: .from) else { return }
        
        let endFrame: CGRect = CGRect(x: 0, y: toVC.view.frame.height, width: toVC.view.frame.width, height: toVC.view.frame.height)
        
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(withDuration: self.duration, animations: {
            
            fromVC.view.frame = endFrame
            
        }) { _ in
            fromVC.view.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
