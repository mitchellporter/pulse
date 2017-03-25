//
//  CreateTaskPresentTransition.swift
//  Pulse
//
//  Created by Design First Apps on 3/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: Double = 0.25
    
    var presenting: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            self.present(context: transitionContext)
        } else {
            self.dismiss(context: transitionContext)
        }
    }
    
    private func present(context: UIViewControllerContextTransitioning) {
        let containerView: UIView = context.containerView
        guard let fromVC: TaskViewController = context.viewController(forKey: .from) as? TaskViewController else { print("Transition failed"); return }
        guard let toVC: CreateTaskViewController = context.viewController(forKey: .to) as? CreateTaskViewController else { print("Transition failed"); return }
        
        let startFrame: CGRect = fromVC.addButton.frame
        let endFrame: CGRect = CGRect(x: startFrame.origin.x - 700, y: startFrame.origin.y - 700, width: 1400, height: 1400)
        let cornerRadius: CGFloat = startFrame.width / 2
        let endCornerRadius: CGFloat = endFrame.width / 2
        
        let mask: UIView = UIView(frame: startFrame)
        mask.alpha = 1.0
        mask.backgroundColor = UIColor.black
        mask.layer.cornerRadius = cornerRadius
        
        let littleCircle: UIBezierPath = UIBezierPath(roundedRect: startFrame, cornerRadius: cornerRadius)
        let bigCircle: UIBezierPath = UIBezierPath(roundedRect: endFrame, cornerRadius: endCornerRadius)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = littleCircle.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.opacity = 1.0
        
        
        let transitionAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        transitionAnimation.fromValue = littleCircle.cgPath
        transitionAnimation.toValue = bigCircle.cgPath
        transitionAnimation.duration = self.duration
        transitionAnimation.fillMode = kCAFillModeForwards
        transitionAnimation.isRemovedOnCompletion = false
        maskLayer.add(transitionAnimation, forKey: "path")
        
        let transitionAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "frame")
        transitionAnimation2.fromValue = startFrame
        transitionAnimation2.toValue = endFrame
        transitionAnimation2.duration = self.duration
        transitionAnimation2.fillMode = kCAFillModeForwards
        transitionAnimation2.isRemovedOnCompletion = false
        maskLayer.add(transitionAnimation2, forKey: "frame")
        
        toVC.view.layer.mask = maskLayer
        
        containerView.layer.addSublayer(fromVC.view.layer)
        containerView.layer.addSublayer(toVC.view.layer)
        
        Delay.wait(self.duration) {
            toVC.view.mask = nil
            toVC.view.layer.mask = nil
            containerView.addSubview(fromVC.view)
            containerView.addSubview(toVC.view)
            
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func dismiss(context: UIViewControllerContextTransitioning) {
        let containerView: UIView = context.containerView
        guard let toVC: TaskViewController = context.viewController(forKey: .to) as? TaskViewController else { print("Transition failed"); return }
        guard let fromVC: CreateTaskViewController = context.viewController(forKey: .from) as? CreateTaskViewController else { print("Transition failed"); return }
        
        let endFrame: CGRect = toVC.addButton.frame
        let startFrame: CGRect = CGRect(x: endFrame.origin.x - 700, y: endFrame.origin.y - 700, width: 1400, height: 1400)
        let cornerRadius: CGFloat = startFrame.width / 2
        let endCornerRadius: CGFloat = endFrame.width / 2
        
        let mask: UIView = UIView(frame: startFrame)
        mask.alpha = 1.0
        mask.backgroundColor = UIColor.black
        mask.layer.cornerRadius = cornerRadius
        
        let littleCircle: UIBezierPath = UIBezierPath(roundedRect: endFrame, cornerRadius: endCornerRadius)
        let bigCircle: UIBezierPath = UIBezierPath(roundedRect: startFrame, cornerRadius: cornerRadius)
        
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = bigCircle.cgPath
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.opacity = 1.0
        
        
        let transitionAnimation: CABasicAnimation = CABasicAnimation(keyPath: "path")
        transitionAnimation.fromValue = bigCircle.cgPath
        transitionAnimation.toValue = littleCircle.cgPath
        transitionAnimation.duration = self.duration
        transitionAnimation.fillMode = kCAFillModeForwards
        transitionAnimation.isRemovedOnCompletion = false
        maskLayer.add(transitionAnimation, forKey: "path")
        
        let transitionAnimation2: CABasicAnimation = CABasicAnimation(keyPath: "frame")
        transitionAnimation2.fromValue = endFrame
        transitionAnimation2.toValue = startFrame
        transitionAnimation2.duration = self.duration
        transitionAnimation2.fillMode = kCAFillModeForwards
        transitionAnimation2.isRemovedOnCompletion = false
        maskLayer.add(transitionAnimation2, forKey: "frame")
        
        fromVC.view.layer.mask = maskLayer
        
        containerView.layer.addSublayer(toVC.view.layer)
        containerView.layer.addSublayer(fromVC.view.layer)
        
        Delay.wait(self.duration) {
            Delay.wait(1.0, closure: { 
                fromVC.view.mask = nil
                fromVC.view.layer.mask = nil
                fromVC.view.layer.removeFromSuperlayer()
                fromVC.view.removeFromSuperview()
            })
            containerView.addSubview(toVC.view)
            
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}
