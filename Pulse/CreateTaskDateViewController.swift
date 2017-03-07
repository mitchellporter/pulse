//
//  CreateTaskDateViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CalendarPicker

class CreateTaskDateViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var calendarPicker: CalendarPicker!
    
    var dueDate: Date? {
        get {
            guard let description: [Date] = self.taskDictionary?[.dueDate] as? [Date] else { return nil }
            guard let dueDate: Date = description.first else { return nil }
            return dueDate
        }
        set {
            let date: Any = newValue as Any
            _ = self.taskDictionary?.updateValue([date], forKey: CreateTaskKeys.dueDate)
        }
    }
    var taskDictionary: [CreateTaskKeys : [Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
        self.setupPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let date: Date = self.dueDate {
            self.calendarPicker.setSelected(date: date)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            print("dismissing!")
            guard let previousViewController: CreateTaskViewController = NavigationManager.getPreviousViewController(CreateTaskViewController.self, from: self) as? CreateTaskViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        } else {
            print("not dismissing!")
        }
    }
    
    private func setupPicker() {
        self.calendarPicker.delegate = self
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = createTaskBackgroundColor
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "assign", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskAssignViewController else { return }
        toVC.taskDictionary = dictionary
    }
}

extension CreateTaskDateViewController: CalendarDelegate {
    
    func dateSelected(date: Date?) {
        self.dueDate = date
    }
}
