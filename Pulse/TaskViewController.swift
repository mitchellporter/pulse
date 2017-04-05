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
    
    @IBOutlet weak var swipeRightGesture: UISwipeGestureRecognizer!
    @IBOutlet weak var swipeLeftGesture: UISwipeGestureRecognizer!
    
    var datasource: [(title: String, color: UIColor, viewController: UIViewController) ] = [(title: String, color: UIColor, viewController: UIViewController)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViewControllers()
        self.setupAppearance()
        self.updateView(with: IndexPath(row: 0, section: 0))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func initializeViewControllers() {
        let myTasksTitle: String = "MY TASKS"
        let myTasksColor: UIColor = appGreen
        let myTasks = MyTasksViewController(nibName: "MyTasksViewController", bundle: nil)
        self.datasource.append((title: myTasksTitle, color: myTasksColor, viewController: myTasks))
        
        let updatesTitle: String = "UPDATES"
        let updatesColor: UIColor = appYellow
        let updates = UpdatesViewController(nibName: "UpdatesViewController", bundle: nil)
        self.datasource.append((title: updatesTitle, color: updatesColor, viewController: updates))
        
        let tasksCreatedTitle: String = "TASKS CREATED"
        let tasksCreatedColor: UIColor = appBlue
        let tasksCreated = CreatedTasksViewController(nibName: "CreatedTasksViewController", bundle: nil)
        self.datasource.append((title: tasksCreatedTitle, color: tasksCreatedColor, viewController: tasksCreated))
        
        let teamTitle: String = "TEAM"
        let teamColor: UIColor = appPurple
        let team = TeamViewController(nibName: "TeamViewController", bundle: nil)
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
    
    fileprivate func scrollViewControllerIntoView(viewController: UIViewController) {
        let previousIndex: Int = self.headerNavigation.selectedIndex.row
        var newIndex: Int = 0
        for (i, item) in self.datasource.enumerated() {
            if item.viewController == viewController {
                newIndex = i
            }
        }
        
        let previousVC: UIViewController = self.datasource[previousIndex].viewController
        viewController.view.frame = self.containerView.bounds
        
        let newX: CGFloat = previousIndex > newIndex ? -previousVC.view.frame.width : previousVC.view.frame.width
        let newViewFrame: CGRect = CGRect(x: newX, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        viewController.view.frame = newViewFrame
        
        self.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
        
        let oldX: CGFloat = previousIndex > newIndex ? previousVC.view.frame.width : -previousVC.view.frame.width
        let oldViewFrame: CGRect = CGRect(x: oldX, y: 0, width: self.containerView.frame.width, height: self.containerView.frame.height)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            viewController.view.frame = self.containerView.bounds
            previousVC.view.frame = oldViewFrame
            
        }, completion: { _ in
            previousVC.view.removeFromSuperview()
        })
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
        
        if segue.identifier == "teamMember" {
            guard let user: User = sender as? User else { return }
            guard let destinationVC: TeamMemberViewController = segue.destination as? TeamMemberViewController else { return }
            destinationVC.user = user
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
    
    @IBAction func swiped(_ sender: UISwipeGestureRecognizer) {
        if sender == self.swipeLeftGesture {
            let index: IndexPath = IndexPath(row: self.headerNavigation.selectedIndex.row + 1, section: 0)
            if index.row < self.datasource.count {
                self.headerNavigation(self.headerNavigation, changedSelectedIndex: index, from: self.headerNavigation.selectedIndex)
                self.headerNavigation.selectedIndex = index
            }
        } else if sender == self.swipeRightGesture {
            let index: IndexPath = IndexPath(row: self.headerNavigation.selectedIndex.row - 1, section: 0)
            if index.row >= 0 {
                self.headerNavigation(self.headerNavigation, changedSelectedIndex: index, from: self.headerNavigation.selectedIndex)
                self.headerNavigation.selectedIndex = index
            }
        }
    }
    
    @IBAction func unwindToTaskViewController(_ segue: UIStoryboardSegue) {
    
        if segue.identifier == "endCreateFlow" || segue.identifier == "" {
            let newIndex: IndexPath = IndexPath(row: 2, section: 0)
            self.headerNavigation(self.headerNavigation, changedSelectedIndex: newIndex, from: self.headerNavigation.selectedIndex)
            self.headerNavigation.selectedIndex = newIndex
        }
    }
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
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, changedSelectedIndex indexPath: IndexPath, from oldIndexPath: IndexPath) {
        self.headerNavigation.color = self.datasource[indexPath.row].color
//        self.updateView(with: indexPath)
        if indexPath != oldIndexPath {
            let viewController: UIViewController = self.datasource[indexPath.row].viewController
            self.scrollViewControllerIntoView(viewController: viewController)
        }
    }
}
