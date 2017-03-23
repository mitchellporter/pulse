//
//  AlertManager.swift
//  PanGestureTransition
//
//  Created by Design First Apps on 11/17/16.
//  Copyright © 2016 Design First Apps. All rights reserved.
//

import UIKit

enum PassiveAlertType {
    case due
    case assigned
    case completed
    case edited
    case update
}

public typealias AlertCompletion = ()->()

class AlertManager {
    
    /* This is the initial class definition. If you need to add functionality, such as adding a new type of alert to this class, use the extension below, and do not modify anything in the initial scope of the class.
     */
    
    enum DefaultAlertType {
        case error
        case defaultAlert
    }
    
    enum CustomAlertType {
        case update
    }
    
    private static var passiveAlert: PassiveAlert?
    
    private static var alertWindow: UIWindow?
    
    /** The window for presenting an alert. */
    private static var window: UIWindow {
        get {
            if self.alertWindow == nil {
                self.setupWindow()
            }
            return self.alertWindow!
        }
        
        set(newWindow) {
            self.alertWindow = newWindow
        }
    }
    
    /** The root UIViewController of the alert. */
    fileprivate static var rootViewController: UIViewController? {
        get {
            guard let rootViewController = self.alertWindow?.rootViewController else { return nil }
            return rootViewController
        }
        set(newRoot) {
            self.window.rootViewController = newRoot
        }
    }
    
    /** Method for initializing a new UIWindow object and setting the class variable. */
    private class func setupWindow() {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.windowLevel = UIWindowLevelAlert
        self.alertWindow = alertWindow
    }
    
    /** This method sets the specified alert view controller as the root on the alert window. */
    private class func setRoot(viewController: UIViewController) {
        self.rootViewController = viewController
    }
    
    /** This method must be called at the end of your load alert method to make the alert visible in the application. */
    fileprivate class func presentAlert(alert: UIViewController) {
        if self.rootViewController == nil {
            self.setRoot(viewController: alert)
            self.window.makeKeyAndVisible()
        }
    }
    
    /** Call this method to dismiss the presented alert. */
    class func dismissAlert() {
        self.setupWindow()
    }
    
    /** Call this method to present a passive alert that requires no user interaction. */
    class func presentPassiveAlert(of type: PassiveAlertType, with data: Any) {
        if self.rootViewController == nil {
            let alert: PassiveAlert = PassiveAlert(frame: CGRect(x: 0, y: -93, width: UIScreen.main.bounds.width, height: 124))
            self.passiveAlert = alert
            alert.load(alertType: type, with: data)
            guard let navigationController: UINavigationController = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController else { return }
            navigationController.view.addSubview(alert)
            UIView.animate(withDuration: 0.2, animations: {
                alert.frame.origin.y = 0
            }, completion: { _ in
                Delay.wait(4) {
                    self.dismissPassiveAlert(alert)
                }
            })
        }
    }
    
    /** Call this method to dismiss a presented passive alert. */
    @objc class func dismissPassiveAlert(_ alert: PassiveAlert) {
        UIView.animate(withDuration: 0.25, animations: {
            if alert.frame.origin.y == 0 {
                alert.frame.origin.y = -alert.frame.height
            }
        }, completion: { _ in
            alert.removeFromSuperview()
            self.passiveAlert = nil
        })
    }
}

extension AlertManager {
    
    // Default Alert Methods
    
    /** Use this method to present a default alert without custom messaging. */
    class func presentDefaultAlert(ofType: DefaultAlertType) {
        switch ofType {
        case .defaultAlert: {
            self.loadDefaultAlert()
        }()
        default: {
            self.loadDefaultAlert()
        }()
        }
    }
    
    /** Use this method to present a default alert with a custom title and/or message. */
    class func presentDefaultAlert(withTitle: String?, andMessage: String?) {
        self.loadDefaultAlert(ofType: "default", title: withTitle, message: andMessage)
    }
    
    /** Use this method to load a default alert without custom messaging. */
    private class func loadDefaultAlert() {
        self.loadDefaultAlert(ofType: "default", title: nil, message: nil)
    }
    
    /** This method loads a default alert and presents it over the application. */
    private class func loadDefaultAlert(ofType: String, title: String?, message: String?) {
        guard let defaultAlert = UIStoryboard(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: ofType) as? AlertController else { print("DefaultAlertController not found with specified identifier."); return }
        if let title = title {
            defaultAlert.titleText = title
        }
        if let message = message {
            defaultAlert.message = message
        }
        self.presentAlert(alert: defaultAlert)
    }
    
    
    // Action alert methods
    
    /** Use this method to present an Action alert without custom messaging. */
    class func presentActionAlert(ofType: DefaultAlertType) {
        self.loadActionAlert()
    }
    
    // THIS SEEMS REDUNDANT TO THE DEFAULT ALERT //
//    /** Use this method to present an Action alert with a custom title and/or message. */
//    class func presentActionAlert(withTitle: String?, andMessage: String?) {
//        self.loadActionAlert(title: withTitle, message: andMessage, completion: nil)
//    }
    
    /** Use this method to present a custom Action alert with functionality to be performed after being presented. */
    class func presentActionAlert(withTitle: String?, andMessage: String?, completion: @escaping AlertCompletion) {
        self.loadActionAlert(ofType: "action", title: withTitle, message: andMessage, completion: completion)
    }
    
    /** Use this method to load an Action alert without custom messaging. */
    private class func loadActionAlert() {
        self.loadActionAlert(ofType: "", title: nil, message: nil, completion: nil)
    }
    
    /** This method loads an Action alert and presents it over the application. */
    private class func loadActionAlert(ofType: String, title: String?, message: String?, completion: AlertCompletion?) {
        guard let defaultAlert = UIStoryboard(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: ofType) as? AlertController else { print("DefaultAlertController not found with specified identifier."); return }
        
        if let title = title {
            defaultAlert.titleText = title
        }
        if let message = message {
            defaultAlert.message = message
        }
        if let completion = completion {
            defaultAlert.completions = [completion]
        }
        self.presentAlert(alert: defaultAlert)
        
        // TODO: Setup View Controller with closures based on user action.
        
    }
    
    // Custom Alert Methods
    /** Use this method to present a custom alert with an optional completion. */
    class func presentAlert(ofType: CustomAlertType, with completion: AlertCompletion?) {
        switch ofType {
        case .update: {
            self.loadDefaultAlert(ofType: "update", title: nil, message: nil)
        }()
        }
    }
    
    /** Use this method to present a custom Interactive alert with optional data. */
    class func presentAlert(ofType: CustomAlertType, with data: Any?) {
        switch ofType {
        case .update: {
            self.loadInteractiveAlert(ofType: "update", title: nil, message: nil, with: data)
        }()
        }
    }
    
    /** This method loads an Interactive alert and presents it over the application. */
    private class func loadInteractiveAlert(ofType: String, title: String?, message: String?, with data: Any?) {
        guard let defaultAlert = UIStoryboard(name: "Alerts", bundle: nil).instantiateViewController(withIdentifier: ofType) as? AlertController else { print("DefaultAlertController not found with specified identifier."); return }
        guard let updateAlertController: UpdateAlertController = defaultAlert as? UpdateAlertController else { return }
        updateAlertController.data = data
        self.presentAlert(alert: defaultAlert)
    }
}
