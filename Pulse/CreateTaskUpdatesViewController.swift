//
//  CreateTaskUpdatesViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskUpdatesViewController: CreateTask {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    var taskDictionary: [CreateTaskKeys : [Any]]?
    
    var selectedDays: Set<WeekDay> {
        get {
            guard let updateIntervals: [WeekDay] = self.taskDictionary?[.updateInterval] as? [WeekDay] else { return Set<WeekDay>() }
            let set = Set<WeekDay>(updateIntervals)
            return set
        }
        set {
            let array: [WeekDay] = [WeekDay](newValue)
            _ = self.taskDictionary?.updateValue(array, forKey: .updateInterval)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setButtonStateFromDictionary()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            guard let previousViewController: CreateTaskAssignViewController = NavigationManager.getPreviousViewController(CreateTaskAssignViewController.self, from: self) as? CreateTaskAssignViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        }
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = createTaskBackgroundColor
        
        self.addCheckOn(button: self.mondayButton)
        self.addCheckOn(button: self.wednesdayButton)
        self.addCheckOn(button: self.fridayButton)
    }
    
    private func addCheckOn(button: UIButton) {
        // Draw check on button
        let pointOne: CGPoint = CGPoint(x: 8.73535156, y: 17.215332)
        let pointTwo: CGPoint = CGPoint(x: 15.6796875, y: 23.4306641)
        let pointThree: CGPoint = CGPoint(x: 24.8242188, y: 11)
        
        let checkLayer: CAShapeLayer = CAShapeLayer()
        checkLayer.frame.size = CGSize(width: 34, height: 34)
        checkLayer.frame.origin = CGPoint(x: 20, y: (button.frame.height/2) - (checkLayer.frame.height/2))
        let checkPath: UIBezierPath = UIBezierPath()
        checkPath.move(to: pointOne)
        checkPath.addLine(to: pointTwo)
        checkPath.addLine(to: pointThree)
        checkLayer.path = checkPath.cgPath
        checkLayer.fillColor = UIColor.clear.cgColor
        checkLayer.strokeColor = createTaskBackgroundColor.cgColor
        checkLayer.lineWidth = 4
        
        button.layer.addSublayer(checkLayer)
    }
    
    private func setButtonStateFromDictionary() {
        for day in self.selectedDays {
            if day == .monday {
                self.setSelected(state: true, button: self.mondayButton)
            }
            if day == .wednesday {
                self.setSelected(state: true, button: self.wednesdayButton)
            }
            if day == .friday {
                self.setSelected(state: true, button: self.fridayButton)
            }
        }
    }
    
    private func addRemoveInterval(_ interval: WeekDay, for button: UIButton) {
        if self.selectedDays.contains(interval) {
            self.selectedDays.remove(interval)
            self.setSelected(state: false, button: button)
        } else {
            self.selectedDays.insert(interval)
            self.setSelected(state: true, button: button)
        }
    }
    
    private func setSelected(state: Bool, button: UIButton) {
        if state {
            // Set button selected state
            button.setTitleColor(createTaskBackgroundColor, for: .normal)
            button.backgroundColor = UIColor.white
        } else {
            // Remove button selected state
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor.clear
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "review", sender: self.taskDictionary)
    }
    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        if sender == self.mondayButton {
            self.addRemoveInterval(.monday, for: sender)
        } else if sender == self.wednesdayButton {
            self.addRemoveInterval(.wednesday, for: sender)
        } else if sender == self.fridayButton {
            self.addRemoveInterval(.friday, for: sender)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary: [CreateTaskKeys : [Any]] = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskReviewViewController else { return }
        toVC.taskDictionary = dictionary
    }
}
