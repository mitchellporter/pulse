//
//  PassiveAlert.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class PassiveAlert: UIView {
    
    private(set) var view: UIView!
    
    override init(frame: CGRect) {
        
        //         1. setup any properties here
        
        //         2. call super.init(frame:)
        super.init(frame: frame)
        
        //         3. Setup view from .xib file
        xibSetup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = self.loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = self.bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(view)
        
        self.loadView()
    }
    
    private func loadViewFromNib() -> UIView {
        self.backgroundColor = UIColor.clear
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PassiveAlert", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    @IBOutlet weak var mascotView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewButton: Button!
    
    var data: Any?
    var alertType: PassiveAlertType?
    var swipeGesture: UISwipeGestureRecognizer!
    
    private func loadView() {
        self.swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(PassiveAlert.viewSwiped))
        self.swipeGesture.delegate = self
        self.swipeGesture.direction = .up
        
        self.addGestureRecognizer(self.swipeGesture)
    }

    func load(alertType: PassiveAlertType, with data: Any) {
        self.alertType = alertType
        self.data = data
        switch(alertType) {
        case .due:
            self.view.backgroundColor = appRed
            self.titleLabel.text = "Your task is due in 24 hrs"
            self.mascotView.image = #imageLiteral(resourceName: "SherburtHi")
        case .assigned:
            self.view.backgroundColor = appDark
            self.titleLabel.text = "You’ve been assigned a new task!"
            self.mascotView.image = #imageLiteral(resourceName: "SherburtNeutral")
        case .completed:
            self.view.backgroundColor = appGreen
            self.titleLabel.text = "A Task you created is now completed"
            self.mascotView.image = #imageLiteral(resourceName: "SherbertUpsideDown")
        case .edited:
            self.view.backgroundColor = appBlue
            self.titleLabel.text = "A task has been edited"
            self.mascotView.image = #imageLiteral(resourceName: "SherburtSidewaysLeft")
        case .update:
            self.view.backgroundColor = appYellow // UIColor("FFBB4A")
            self.titleLabel.text = "An progress update was sent to you"
            self.mascotView.image = #imageLiteral(resourceName: "SherburtHi")
        }
    }
    
    @IBAction func viewPressed(_ sender: UIButton) {
        // Navigate to appropriate view controller to display notification info, then dismiss alert.
        AlertManager.dismissPassiveAlert(self)
        
        guard let alertType: PassiveAlertType = self.alertType else { return }
        switch(alertType) {
        case .due:
            
            break
        case .assigned:
            guard let taskInvitation: TaskInvitation = self.data as? TaskInvitation else { return }
            NavigationManager.presentTaskAssigned(taskInvitation: taskInvitation)
            break
        case .completed:
            guard let task: Task = self.data as? Task else { return }
            NavigationManager.presentTaskCompleted(task: task)
            break
        case .edited:
            
            break
        case .update:
            guard let update: Update = self.data as? Update else { return }
            NavigationManager.presentUpdateReceived(update: update)
            break
        }
    }
    
    func viewSwiped() {
        AlertManager.dismissPassiveAlert(self)
    }
}

extension PassiveAlert: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view.isDescendant(of: self) {
                return true
            }
        }
        return false
    }
}
