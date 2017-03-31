//
//  NavigationManager.swift
//  Pulse
//
//  Created by Design First Apps on 3/3/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NavigationManager {
    
    class func loadFeed() {
        OperationQueue.main.addOperation({
            if User.currentUser() != nil {
                guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else {return}
                if navigationController.viewControllers.count == 1 {
                    guard let rootViewController = navigationController.viewControllers.first as? HomeViewController else {return}
                    guard let feed = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() else {return}
                    navigationController.setViewControllers([rootViewController, feed], animated: false)
                }
            }
        })
    }
    
    static func getPreviousViewController(_ ofType: AnyClass, from viewController: UIViewController) -> UIViewController? {
        if let navigationController = viewController.navigationController {
            return navigationController.viewControllers.last
//            if let index: Int = navigationController.viewControllers.index(of: viewController) {
//                let previousViewController: UIViewController = navigationController.viewControllers[index - 1]
//                return previousViewController
//            }
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
//        let className: String = NSStringFromClass(viewControllerClass)
//        guard let aClass = NSClassFromString(className) as? UIViewController.Type else { return false }
//        let vc = UIStoryboard(name: String, bundle: Bundle?)
//        let viewController: UIViewController = aClass.init()
//        navigationStack.append(viewController)
//        guard let vc = viewController as? TaskViewController else { return false }
//        print("Successfully initialized an instance of TaskViewController")
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
    
    static func dismissOnboarding() {
        let mainController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() as! TaskViewController
        guard let navigationController = UIApplication.shared.delegate?.window??.rootViewController as? NavigationController else { return }
        guard let rootController = navigationController.viewControllers[0] as? HomeViewController else { return }
        let viewControllers = [rootController, mainController]
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}
