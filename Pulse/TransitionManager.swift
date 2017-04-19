//
//  TransitionManager.swift
//  Pulse
//
//  Created by Design First Apps on 4/18/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class TransitionManager {
    
    var transition: AnimatedTransition?
    
    class func transitionForViewControllers(from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (fromVC  is HomeViewController && toVC is SignInViewController) || (fromVC is SignInViewController && toVC is HomeViewController) {
            let transition: SignInTransition = SignInTransition()
            transition.presenting = fromVC is HomeViewController ? true : false
            return FadeTransition()
        } else if fromVC is TaskViewController && toVC is CreateTaskViewController {
            return CreateTaskPresentTransition(from: fromVC, to: toVC)
        } else if fromVC is CreateTaskViewController && toVC is TaskViewController {
            return CreateTaskPresentTransition(from: fromVC, to: toVC)
        } else if (fromVC is TaskViewController && toVC is ViewTaskViewController) || (fromVC is ViewTaskViewController && toVC is TaskViewController) {
            return ModalTransition(from: fromVC, to: toVC)
        } else if (fromVC is TaskViewController && toVC is EditTaskViewController) || (fromVC is EditTaskViewController && toVC is TaskViewController) {
            return ModalTransition(from: fromVC, to: toVC)
        } else if (fromVC is TaskViewController && toVC is ViewUpdateViewController) || (fromVC is ViewUpdateViewController && toVC is TaskViewController) {
            return ModalTransition(from: fromVC, to: toVC)
        } else if (fromVC is TaskViewController && toVC is TaskUpdateViewController) || (fromVC is TaskUpdateViewController && toVC is TaskViewController) {
            return ModalTransition(from: fromVC, to: toVC)
        } else if (fromVC is TaskViewController && toVC is TeamMemberViewController) || (fromVC is TeamMemberViewController && toVC is TaskViewController) {
            return ModalTransition(from: fromVC, to: toVC)
        } else if fromVC is HomeViewController || fromVC is SignInViewController {
            return NoAnimationTransition()
        }
        
        return FadeTransition()
    }
}
