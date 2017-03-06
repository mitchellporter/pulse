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
    var taskDictionary: [CreateTaskKeys : [Any]]?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskReviewViewController else { return }
        toVC.taskDictionary = dictionary
    }

}
