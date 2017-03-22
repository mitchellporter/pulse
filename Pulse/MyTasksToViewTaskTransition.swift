//
//  MyTasksToViewTaskTransition.swift
//  Pulse
//
//  Created by Design First Apps on 3/20/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class MyTasksToViewTaskTransition: NSObject, UIViewControllerAnimatedTransitioning {

    var duration: Double = 0.3
    
    var transitionCell: UITableViewCell?
    
    var transitionImage: UIImage?
    var transitionImageFrame: CGRect?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView: UIView = transitionContext.containerView
        guard let fromVC: TaskViewController = transitionContext.viewController(forKey: .from) as? TaskViewController else { return }
        guard let toVC: ViewTaskViewController = transitionContext.viewController(forKey: .to) as? ViewTaskViewController else { return }
        
        guard let cell: UITableViewCell = self.transitionCell else { return }
        
        let coverView: UIView = UIView(frame: containerView.frame)
        coverView.backgroundColor = fromVC.view.backgroundColor
        coverView.alpha = 0.0
        
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, 0.0)
        guard let cgContextFrom: CGContext = UIGraphicsGetCurrentContext() else { UIGraphicsEndImageContext(); return }
        cell.layer.render(in: cgContextFrom)
        guard let img: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { UIGraphicsEndImageContext(); return }
        UIGraphicsEndImageContext()
        self.transitionImage = img
        self.transitionImageFrame = cell.frame
        
        guard let image: UIImage = self.transitionImage else { return }
        guard let imageFrame: CGRect = self.transitionImageFrame else { return }
        let imageView: UIImageView = UIImageView(image: image)
        imageView.frame = imageFrame
        
        toVC.view.alpha = 0.0
        containerView.addSubview(coverView)
        containerView.addSubview(toVC.view)
        containerView.addSubview(imageView)
        
        UIView.animateKeyframes(withDuration: self.duration, delay: 0.0, options: [], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3, animations: { 
                coverView.alpha = 1.0
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3, animations: {
                imageView.frame.origin = CGPoint(x: imageView.frame.origin.x, y: 50)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                toVC.view.alpha = 1.0
            })
            
        }) { (finished) in
            coverView.removeFromSuperview()
            imageView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
