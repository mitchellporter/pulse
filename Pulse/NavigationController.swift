//
//  NavigationController.swift
//  Pulse
//
//  Created by Design First Apps on 3/3/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var animator: UIViewControllerAnimatedTransitioning?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension NavigationController: UINavigationControllerDelegate {
    func navigationController(_ animationControllerForfromtonavigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (fromVC  is HomeViewController && toVC is SignInViewController) || (fromVC is SignInViewController && toVC is HomeViewController) {
            let transition: SignInTransition = SignInTransition()
            transition.presenting = fromVC is HomeViewController ? true : false
            return FadeTransition()
        } else if fromVC is Onboarding && toVC is Onboarding {
            return FadeTransition()
//        } else if fromVC is TaskViewController && toVC is ViewTaskViewController {
//            return self.animator
        } else if fromVC is CreateTask && toVC is CreateTask {
            return FadeTransition()
        } else if fromVC is TaskViewController && toVC is CreateTaskViewController {
            let transition: CreateTaskPresentTransition = CreateTaskPresentTransition()
            transition.presenting = true
            return transition
        } else if fromVC is CreateTaskViewController && toVC is TaskViewController {
            let transition: CreateTaskPresentTransition = CreateTaskPresentTransition()
            transition.presenting = false
            return transition
        } else if (fromVC is TaskViewController && toVC is ViewTaskViewController) || (fromVC is ViewTaskViewController && toVC is TaskViewController) {
            let transition: ModalTransition = ModalTransition()
            transition.presenting = fromVC is TaskViewController ? true : false
            return transition
        } else if (fromVC is TaskViewController && toVC is EditTaskViewController) || (fromVC is EditTaskViewController && toVC is TaskViewController) {
            let transition: ModalTransition = ModalTransition()
            transition.presenting = fromVC is TaskViewController ? true : false
            return transition
        } else if (fromVC is TaskViewController && toVC is ViewUpdateViewController) || (fromVC is ViewUpdateViewController && toVC is TaskViewController) {
            let transition: ModalTransition = ModalTransition()
            transition.presenting = fromVC is TaskViewController ? true : false
            return transition
        } else if (fromVC is TaskViewController && toVC is TaskUpdateViewController) || (fromVC is TaskUpdateViewController && toVC is TaskViewController) {
            let transition: ModalTransition = ModalTransition()
            transition.presenting = fromVC is TaskViewController ? true : false
            return transition
        } else if (fromVC is TaskViewController && toVC is TeamMemberViewController) || (fromVC is TeamMemberViewController && toVC is TaskViewController) {
            let transition: ModalTransition = ModalTransition()
            transition.presenting = fromVC is TaskViewController ? true : false
            return transition
        } else if (fromVC is ViewTeamMemberTaskViewController && toVC is TeamMemberViewController) || (fromVC is TeamMemberViewController && toVC is ViewTeamMemberTaskViewController) {
            return FadeTransition()
        } else if fromVC is HomeViewController || fromVC is SignInViewController {
            return NoAnimationTransition()
        } else if (fromVC is SendTaskViewController || toVC is SendTaskViewController) {
            return FadeTransition()
        } else if (fromVC is AddressBookViewController || toVC is AddressBookViewController) {
            return FadeTransition()
        }
        return nil
    }
}
