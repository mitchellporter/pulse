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
        didSet {
            let date: Any = self.dueDate as Any
            _ = self.taskDictionary?.updateValue([date], forKey: CreateTaskKeys.dueDate)
        }
    }
    var taskDictionary: [CreateTaskKeys : [Any]]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupPicker()
    }
    
    private func setupPicker() {
        self.calendarPicker.delegate = self
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
