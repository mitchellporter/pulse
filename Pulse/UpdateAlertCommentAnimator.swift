//
//  UpdateAlertCommentAnimator.swift
//  Pulse
//
//  Created by Design First Apps on 3/13/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class UpdateAlertCommentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 1.0
    
    var presenting: Bool = true
    
    let m34: CGFloat = -1.0 / 1000

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if self.presenting {
            self.presenting(context: transitionContext)
        } else {
            self.dismissing(context: transitionContext)
        }
    }
    
    private func presenting(context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to) as? UpdateAlertCommentViewController else { return }
        guard let fromVC = context.viewController(forKey: .from) as? UpdateAlertController else { return }

        fromVC.view.isHidden = true
        
        let backingView: UIView = UIView(frame: UIScreen.main.bounds)
        backingView.backgroundColor = UIColor(black: 1, alpha: 0.74)
        backingView.layer.zPosition = -CGFloat(FLT_MAX)
        context.containerView.addSubview(backingView)
        
        UIGraphicsBeginImageContextWithOptions(fromVC.alertView.bounds.size, false, 0.0)
        guard let cgContextFrom: CGContext = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return }
        fromVC.alertView.layer.render(in: cgContextFrom)
        guard let imgFrom: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { UIGraphicsEndImageContext(); return }
        UIGraphicsEndImageContext()
        let viewone: UIImageView = UIImageView(image: imgFrom)
        viewone.frame = fromVC.alertView.frame
        // let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        // snapshot.frame.origin.x = -50
        context.containerView.addSubview(viewone)
        
        UIGraphicsBeginImageContextWithOptions(fromVC.alertView.bounds.size, false, 0.0)
        guard let cgContext: CGContext = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return }
        toVC.alertView.layer.render(in: cgContext)
        guard let img: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { UIGraphicsEndImageContext(); return }
        UIGraphicsEndImageContext()
        let viewtwo: UIImageView = UIImageView(image: img)
        viewtwo.frame = fromVC.alertView.frame
        // let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        // snapshot.frame.origin.x = -50
        context.containerView.addSubview(viewtwo)
        
        var rotationAndPerspectiveTransform: CATransform3D = CATransform3DIdentity
        rotationAndPerspectiveTransform.m34 = self.m34
        let rotationAndPerspectiveTransform1: CATransform3D = CATransform3DRotate(rotationAndPerspectiveTransform, -CGFloat(M_PI) / 2, 0.0, 1.0, 0.0)
        let rotationAndPerspectiveTransform2: CATransform3D = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(M_PI) / 2, 0.0, 1.0, 0.0)
        viewtwo.layer.transform = rotationAndPerspectiveTransform2
        
        UIView.animateKeyframes(withDuration: self.duration, delay: 0.0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.duration / 2, animations: {
                viewone.layer.transform = rotationAndPerspectiveTransform1
            })
            
            UIView.addKeyframe(withRelativeStartTime: self.duration / 2, relativeDuration: self.duration / 2, animations: {
                viewtwo.layer.transform = CATransform3DIdentity
            })
            
        }) { (finished) in
            context.containerView.addSubview(toVC.view)
            toVC.view.backgroundColor = backingView.backgroundColor
            viewone.removeFromSuperview()
            viewtwo.removeFromSuperview()
            backingView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
    
    private func dismissing(context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController(forKey: .to) as? UpdateAlertController else { return }
        guard let fromVC = context.viewController(forKey: .from) as? UpdateAlertCommentViewController else { return }
        fromVC.view.isHidden = true
        
        let backingView: UIView = UIView(frame: UIScreen.main.bounds)
        backingView.backgroundColor = UIColor(black: 1, alpha: 0.74)
        backingView.layer.zPosition = -CGFloat(FLT_MAX)
        context.containerView.addSubview(backingView)
        
        UIGraphicsBeginImageContextWithOptions(fromVC.alertView.bounds.size, false, 0.0)
        guard let cgContextFrom: CGContext = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return }
        fromVC.alertView.layer.render(in: cgContextFrom)
        guard let imgFrom: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { UIGraphicsEndImageContext(); return }
        UIGraphicsEndImageContext()
        let viewone: UIImageView = UIImageView(image: imgFrom)
        viewone.frame = fromVC.alertView.frame
        // let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        // snapshot.frame.origin.x = -50
        context.containerView.addSubview(viewone)
        
        UIGraphicsBeginImageContextWithOptions(fromVC.alertView.bounds.size, false, 0.0)
        guard let cgContext: CGContext = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return }
        toVC.alertView.layer.render(in: cgContext)
        guard let img: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { UIGraphicsEndImageContext(); return }
        UIGraphicsEndImageContext()
        let viewtwo: UIImageView = UIImageView(image: img)
        viewtwo.frame = fromVC.alertView.frame
        // let snapshot = toVC.view.snapshotView(afterScreenUpdates: true)
        // snapshot.frame.origin.x = -50
        context.containerView.addSubview(viewtwo)
        
        var rotationAndPerspectiveTransform: CATransform3D = CATransform3DIdentity
        rotationAndPerspectiveTransform.m34 = self.m34
        let rotationAndPerspectiveTransform1: CATransform3D = CATransform3DRotate(rotationAndPerspectiveTransform, CGFloat(M_PI) / 2, 0.0, 1.0, 0.0)
        let rotationAndPerspectiveTransform2: CATransform3D = CATransform3DRotate(rotationAndPerspectiveTransform, -CGFloat(M_PI) / 2, 0.0, 1.0, 0.0)
        viewtwo.layer.transform = rotationAndPerspectiveTransform2
        
        UIView.animateKeyframes(withDuration: self.duration, delay: 0.0, options: .calculationModeCubic, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: self.duration / 2, animations: {
                viewone.layer.transform = rotationAndPerspectiveTransform1
            })
            
            UIView.addKeyframe(withRelativeStartTime: self.duration / 2, relativeDuration: self.duration / 2, animations: {
                viewtwo.layer.transform = CATransform3DIdentity
            })
            
        }) { (finished) in
            toVC.view.isHidden = false
            toVC.view.backgroundColor = backingView.backgroundColor
            viewone.removeFromSuperview()
            viewtwo.removeFromSuperview()
            backingView.removeFromSuperview()
            context.completeTransition(!context.transitionWasCancelled)
        }
    }
}

struct AnimationHelper {
    static func yRotation(angle: Double) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(angle), 0.0, 1.0, 0.0)
    }
    
    static func perspectiveTransformForContainerView(containerView: UIView) {
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
    }
}
