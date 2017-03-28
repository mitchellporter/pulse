//
//  TaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData
import UIAdditions

class TaskViewController: UIViewController {
    
    @IBOutlet weak var headerNavigation: HeaderNavigation!
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var containerView: UIView!
    
    var datasource: [(title: String, color: UIColor, viewController: UIViewController)] = [(title: String, color: UIColor, viewController: UIViewController)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViewControllers()
        self.setupAppearance()
        self.updateView(with: IndexPath(row: 0, section: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateView(with: IndexPath(row: 0, section: 0))
        
        Delay.wait(0.1) {
            self.updateView(with: IndexPath(row: 0, section: 0))
        }
    }
    
    private func initializeViewControllers() {
        let myTasksTitle: String = "MY TASKS"
        let myTasksColor: UIColor = appGreen
        let myTasks = MyTasksViewController(nibName: "MyTasksViewController", bundle: nil)
        self.datasource.append((title: myTasksTitle, color: myTasksColor, viewController: myTasks))
        
        let updatesTitle: String = "UPDATES"
        let updatesColor: UIColor = appYellow
        let updates = MyTasksViewController(nibName: "UpdatesViewController", bundle: nil)
        self.datasource.append((title: updatesTitle, color: updatesColor, viewController: updates))
        
        let tasksCreatedTitle: String = "TASKS CREATED"
        let tasksCreatedColor: UIColor = appBlue
        let tasksCreated = MyTasksViewController(nibName: "CreatedTasksViewController", bundle: nil)
        self.datasource.append((title: tasksCreatedTitle, color: tasksCreatedColor, viewController: tasksCreated))
        
        let teamTitle: String = "TEAM"
        let teamColor: UIColor = appPurple
        let team = UIViewController()
        team.view.backgroundColor = teamColor
        self.datasource.append((title: teamTitle, color: teamColor, viewController: team))
    }
    
    private func updateContainerView(with viewController: UIViewController) {
        for view in self.containerView.subviews {
            view.removeFromSuperview()
        }
        
        self.addChildViewController(viewController)
        
        self.containerView.addSubview(viewController.view)
        viewController.view.frame = self.containerView.bounds
        viewController.didMove(toParentViewController: self)
    }
    
    private func setupAppearance() {
        self.addButton.layer.backgroundColor = createTaskBackgroundColor.cgColor
        
        let antiAliasingRing: CAShapeLayer = CAShapeLayer()
        antiAliasingRing.fillColor = UIColor.clear.cgColor
        antiAliasingRing.strokeColor = UIColor.white.cgColor
        antiAliasingRing.lineWidth = 1.0
        antiAliasingRing.path = UIBezierPath(roundedRect: self.addButton.bounds, cornerRadius: self.addButton.layer.cornerRadius).cgPath
        self.addButton.layer.addSublayer(antiAliasingRing)
        
        self.setupHeaderNavigation()
    }
    
    private func setupHeaderNavigation() {
        self.headerNavigation.delegate = self
        self.headerNavigation.color = self.datasource[0].color
        self.headerNavigation.reloadTitles()
    }
    
    fileprivate func updateView(with indexPath: IndexPath) {
        let viewController: UIViewController = self.datasource[indexPath.row].viewController
        self.updateContainerView(with: viewController)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let viewTaskViewController = segue.destination as? ViewTaskViewController {
            if let task: Task = sender as? Task {
                viewTaskViewController.task = task
            }
            
            if let taskInvite: TaskInvitation = sender as? TaskInvitation {
                viewTaskViewController.taskInvite = taskInvite
            }
        }
        if let editTaskViewController = segue.destination as? EditTaskViewController {
            if let task: Task = sender as? Task {
                editTaskViewController.task = task
            }
            
            if let taskInvite: TaskInvitation = sender as? TaskInvitation {
                editTaskViewController.taskInvite = taskInvite
            }
        }
        
        if segue.identifier == "giveUpdate" {
            guard let destination: TaskUpdateViewController = segue.destination as? TaskUpdateViewController else { return }
            if let update: Update = sender as? Update {
                destination.update = update
            }
            
            if let task: Task = sender as? Task {
                destination.task = task
            }
        } else if segue.identifier == "viewUpdate" {
            
            guard let destination: ViewUpdateViewController = segue.destination as? ViewUpdateViewController else { return }
            if let update: Update = sender as? Update {
                destination.update = update
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
    
    @IBAction func unwindToTaskViewController(_ segue: UIStoryboardSegue) {}
}

extension TaskViewController: HeaderNavigationDelegate {
    
    func numberOfSections(in headerNavigation: HeaderNavigation) -> Int {
        return 1
    }
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, titleForIndex indexPath: IndexPath) -> String? {
        return self.datasource[indexPath.row].title
    }
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, changedSelectedIndex indexPath: IndexPath) {
        self.headerNavigation.color = self.datasource[indexPath.row].color
        self.updateView(with: indexPath)
    }
}
