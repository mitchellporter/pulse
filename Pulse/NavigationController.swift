//
//  NavigationController.swift
//  Pulse
//
//  Created by Design First Apps on 3/3/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

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
        
        if fromVC is Onboarding && toVC is Onboarding {
            return OnboardingTransition()
        }
        return nil
    }
}
