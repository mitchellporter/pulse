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
    
    class func willSearchAndSetNavigationStackFor(viewControllerClass: AnyClass) -> Bool {
        guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else {return false}
        var navigationStack = [UIViewController]()
        for vc in navigationController.viewControllers {
            navigationStack.append(vc)
            if vc.isKind(of: viewControllerClass) {
                navigationController.viewControllers = navigationStack
                return true
            }
        }
        return false
    }
    
    static func presentUpdateReceived(update: Update) {
        if self.willSearchAndSetNavigationStackFor(viewControllerClass: TaskViewController.self) {
            guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else { return }
            guard let taskController = navigationController.viewControllers.last as? TaskViewController else { return }
            
            taskController.performSegue(withIdentifier: "viewUpdate", sender: update)
        }
    }
    
    static func presentUpdateRequestReceived(updateRequest: Update) {
        if self.willSearchAndSetNavigationStackFor(viewControllerClass: TaskViewController.self) {
            guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else { return }
            guard let taskController = navigationController.viewControllers.last as? TaskViewController else { return }
            
            taskController.performSegue(withIdentifier: "giveUpdate", sender: updateRequest)
        }
    }
    
    static func presentTaskCompleted(task: Task) {
        if self.willSearchAndSetNavigationStackFor(viewControllerClass: TaskViewController.self) {
            guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else { return }
            guard let taskController = navigationController.viewControllers.last as? TaskViewController else { return }
            
            taskController.performSegue(withIdentifier: "editTask", sender: task)
        }
    }
    
    static func presentTaskAssigned(taskInvitation: TaskInvitation) {
        if self.willSearchAndSetNavigationStackFor(viewControllerClass: TaskViewController.self) {
            guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else { return }
            guard let taskController = navigationController.viewControllers.last as? TaskViewController else { return }
            
            taskController.performSegue(withIdentifier: "viewTask", sender: taskInvitation)
        }
    }
}
