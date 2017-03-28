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
    
    enum ViewMode: Int {
        case myTasks
        case updates
        case createdTasks
    }
    
    @IBOutlet weak var headerNavigation: HeaderNavigation!
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var myTasksButton: Button!
    @IBOutlet weak var updatesButton: Button!
    @IBOutlet weak var createdTasksButton: Button!
    

    private var viewControllers: [UIViewController] = [UIViewController]()
    private var selectionDot: UIImageView = UIImageView()
    fileprivate var modeSelected: ViewMode = .myTasks {
        didSet {
            if oldValue != self.modeSelected {
                self.updateView(mode: self.modeSelected)
            }
        }
    }
    
    fileprivate var headerTitles: [String] = ["MY TASKS", "UPDATES", "TASK CREATED", "TEAM"]
    fileprivate var headerColors: [UIColor] = [appGreen, appYellow, appBlue, appPurple]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.initializeViewControllers()
        self.updateView(mode: self.modeSelected)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateView(mode: self.modeSelected)
        
        Delay.wait(0.1) { 
            self.updateView(mode: self.modeSelected)
        }
    }
    
    private func initializeViewControllers() {
        let myTasks = MyTasksViewController(nibName: "MyTasksViewController", bundle: nil)
        let updates = UpdatesViewController(nibName: "UpdatesViewController", bundle: nil)
        let createdTasks = CreatedTasksViewController(nibName: "CreatedTasksViewController", bundle: nil)
        
        self.viewControllers.append(contentsOf: [myTasks, updates, createdTasks])
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
        self.headerNavigation.color = self.headerColors[0]
        self.headerNavigation.reloadTitles()
    }
    
    private func updateView(mode: ViewMode) {
//        let fadeAlpha: CGFloat = 0.4
//        switch mode {
//        case .myTasks:
//            self.headerNavigationContainer.backgroundColor = appGreen
//            self.myTasksButton.alpha = 1
//            self.updatesButton.alpha = fadeAlpha
//            self.createdTasksButton.alpha = fadeAlpha
//            self.updateContainerView(with: self.viewControllers[0])
//            
//            guard let buttonTitleFrame: CGRect = self.myTasksButton.titleLabel?.superview?.convert(self.myTasksButton.titleLabel!.frame, to: nil) else { return }
//            let image: UIImage = #imageLiteral(resourceName: "WhiteDot")
//            self.selectionDot.image = image
//            self.selectionDot.frame.size = image.size
//            let dotOrigin: CGPoint = CGPoint(x: buttonTitleFrame.origin.x - 6 - self.selectionDot.bounds.width, y: self.myTasksButton.center.y - (self.selectionDot.bounds.height / 2))
//            self.selectionDot.frame.origin = dotOrigin
////            self.selectionDot.center.y = self.myTasksButton.center.y
//            self.view.addSubview(self.selectionDot)
//        case .updates:
//            self.headerNavigationContainer.backgroundColor = appYellow
//            self.myTasksButton.alpha = fadeAlpha
//            self.updatesButton.alpha = 1
//            self.createdTasksButton.alpha = fadeAlpha
//            self.updateContainerView(with: self.viewControllers[1])
//            
//            guard let buttonTitleFrame: CGRect = self.updatesButton.titleLabel?.superview?.convert(self.updatesButton.titleLabel!.frame, to: nil) else { return }
//            let image: UIImage = #imageLiteral(resourceName: "WhiteDot")
//            self.selectionDot.image = image
//            self.selectionDot.frame.size = image.size
//            let dotOrigin: CGPoint = CGPoint(x: buttonTitleFrame.origin.x - 6 - self.selectionDot.bounds.width, y: self.updatesButton.center.y - (self.selectionDot.bounds.height / 2))
//            self.selectionDot.frame.origin = dotOrigin
//            //            self.selectionDot.center.y = self.myTasksButton.center.y
//            self.view.addSubview(self.selectionDot)
//        case .createdTasks:
//            self.headerNavigationContainer.backgroundColor = appBlue
//            self.createdTasksButton.alpha = 1
//            self.updatesButton.alpha = fadeAlpha
//            self.myTasksButton.alpha = fadeAlpha
//            self.updateContainerView(with: self.viewControllers[2])
//            
//            guard let buttonTitleFrame: CGRect = self.createdTasksButton.titleLabel?.superview?.convert(self.createdTasksButton.titleLabel!.frame, to: nil) else { return }
//            let image: UIImage = #imageLiteral(resourceName: "WhiteDot")
//            self.selectionDot.image = image
//            self.selectionDot.frame.size = image.size
//            let dotOrigin: CGPoint = CGPoint(x: buttonTitleFrame.origin.x - 6 - self.selectionDot.bounds.width, y: self.createdTasksButton.center.y - (self.selectionDot.bounds.height / 2))
//            self.selectionDot.frame.origin = dotOrigin
//            //            self.selectionDot.center.y = self.myTasksButton.center.y
//            self.view.addSubview(self.selectionDot)
//        }
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
    
    @IBAction func unwindToTaskViewController(_ segue: UIStoryboardSegue) {}
}

extension TaskViewController: HeaderNavigationDelegate {
    
    func numberOfSections(in headerNavigation: HeaderNavigation) -> Int {
        return 1
    }
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, numberOfItemsInSection section: Int) -> Int {
        return self.headerTitles.count
    }
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, titleForIndex indexPath: IndexPath) -> String? {
        return self.headerTitles[indexPath.row]
    }
    
    func headerNavigation(_ headerNavigation: HeaderNavigation, changedSelectedIndex indexPath: IndexPath) {
        // Do something with the view
        self.headerNavigation.color = self.headerColors[indexPath.row]
    }
}
