//
//  NavigationManager.swift
//  Pulse
//
//  Created by Design First Apps on 3/3/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NavigationManager {
    
    static func getPreviousViewController(_ ofType: AnyClass, from viewController: UIViewController) -> UIViewController? {
        if let navigationController = viewController.navigationController {
            return navigationController.viewControllers.last
            if let index: Int = navigationController.viewControllers.index(of: viewController) {
                let previousViewController: UIViewController = navigationController.viewControllers[index - 1]
                return previousViewController
            }
        } else {
            if viewController.presentingViewController != nil {
                return viewController.presentingViewController
            }
        }
        return nil
    }
}
