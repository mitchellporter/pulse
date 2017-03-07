//
//  TaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    enum ViewMode: Int {
        case myTasks
        case updates
        case createdTasks
    }
    
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var myTasksButton: Button!
    @IBOutlet weak var updatesButton: Button!
    @IBOutlet weak var createdTasksButton: Button!
    

    private var viewControllers: [UIViewController] = [UIViewController]()
    
    fileprivate var modeSelected: ViewMode = .myTasks {
        didSet {
            if oldValue != self.modeSelected {
                self.updateView(mode: self.modeSelected)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        self.initializeViewControllers()
        self.updateView(mode: self.modeSelected)
    }
    
    private func initializeViewControllers() {
        let myTasks = MyTasksViewController(nibName: "MyTasksViewController", bundle: nil)
        let updates = UpdatesViewController(nibName: "UpdatesViewController", bundle: nil)
        let createdTasks = CreatedTasksViewController(nibName: "CreatedTasksViewController", bundle: nil)
        
        self.viewControllers.append(contentsOf: [myTasks, updates, createdTasks])
    }
    
    private func updateContainerView(with viewController: UIViewController) {
        self.addChildViewController(viewController)
        
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = self.containerView.bounds
        viewController.didMove(toParentViewController: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let task: Task = sender as? Task else { return }
        if let viewTaskViewController = segue.destination as? ViewTaskViewController {
            viewTaskViewController.task = task
        }
        if let editTaskViewController = segue.destination as? EditTaskViewController {
            editTaskViewController.task = task
        }
    }
    
    private func setupAppearance() {
        self.addButton.backgroundColor = createTaskBackgroundColor
    }
    
    private func updateView(mode: ViewMode) {
        switch mode {
        case .myTasks:
            self.myTasksButton.alpha = 1
            self.updatesButton.alpha = 0.3
            self.createdTasksButton.alpha = 0.3
            self.updateContainerView(with: self.viewControllers[0])
        case .updates:
            self.myTasksButton.alpha = 0.3
            self.updatesButton.alpha = 1
            self.createdTasksButton.alpha = 0.3

            self.updateContainerView(with: self.viewControllers[1])
        case .createdTasks:
            self.createdTasksButton.alpha = 1
            self.updatesButton.alpha = 0.3
            self.myTasksButton.alpha = 0.3
            self.updateContainerView(with: self.viewControllers[2])
        }
    }

    @IBAction func myTasksPressed(_ sender: UIButton) {
        self.modeSelected = .myTasks
    }
    
    @IBAction func updatesPresssed(_ sender: UIButton!) {
        self.modeSelected = .updates
    }
    
    @IBAction func createdTasksPressed(_ sender: UIButton) {
        self.modeSelected = .createdTasks
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
}
