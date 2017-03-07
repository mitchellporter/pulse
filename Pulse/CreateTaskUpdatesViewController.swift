//
//  CreateTaskUpdatesViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskUpdatesViewController: UIViewController {

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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            print("dismissing!")
            guard let previousViewController: CreateTaskAssignViewController = NavigationManager.getPreviousViewController(CreateTaskAssignViewController.self, from: self) as? CreateTaskAssignViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        } else {
            print("not dismissing!")
        }
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = createTaskBackgroundColor
    }
    
    private func addRemoveInterval(_ interval: WeekDay) {
        if self.selectedDays.contains(interval) {
            self.selectedDays.remove(interval)
        } else {
            self.selectedDays.insert(interval)
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
        self.performSegue(withIdentifier: "review", sender: nil)
    }
    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        if sender == self.mondayButton {
            self.addRemoveInterval(.monday)
        } else if sender == self.wednesdayButton {
            self.addRemoveInterval(.wednesday)
        } else if sender == self.fridayButton {
            self.addRemoveInterval(.friday)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskReviewViewController else { return }
        toVC.taskDictionary = dictionary
    }

}
