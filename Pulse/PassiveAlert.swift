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
            self.titleLabel.textColor = UIColor.white
            self.titleLabel.text = "You have a task due in 1 day!"
            self.viewButton.setTitleColor(UIColor.white, for: .normal)
            self.viewButton.borderColor = UIColor.white
        case .assigned:
            self.view.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.black
            self.titleLabel.text = "You’ve been assigned a task"
            self.viewButton.setTitleColor(UIColor("028DF2"), for: .normal)
            self.viewButton.borderColor = UIColor("028DF2")
        case .completed:
            self.view.backgroundColor = appGreen
            self.titleLabel.textColor = UIColor.white
            self.titleLabel.text = "A Task you created has been completed!"
            self.viewButton.setTitleColor(UIColor.white, for: .normal)
            self.viewButton.borderColor = UIColor.white
        case .edited:
            self.view.backgroundColor = appBlue
            self.titleLabel.textColor = UIColor.white
            self.titleLabel.text = "A task has been edited"
            self.viewButton.setTitleColor(UIColor.white, for: .normal)
            self.viewButton.borderColor = UIColor.white
        case .update:
            self.view.backgroundColor = appYellow
            self.titleLabel.textColor = UIColor("303030")
            self.titleLabel.text = "An progress update was sent"
            self.viewButton.setTitleColor(UIColor("434343"), for: .normal)
            self.viewButton.borderColor = UIColor("151515")
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
            guard let task: Task = self.data as? Task else { return }
            NavigationManager.presentTaskAssigned(task: task)
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
