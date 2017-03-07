//
//  CreateTaskAssignViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskAssignViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var assignDescriptionLabel: UILabel!
    var taskDictionary: [CreateTaskKeys : [Any]]?
    var tableViewTopInset: CGFloat = 30
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    var assignees: Set<String> {
        get {
            guard let assignees: [String] = self.taskDictionary?[.assignees] as? [String] else { return Set<String>() }
            let set = Set<String>(assignees)
            return set
        }
        set {
            let assigneesArray: [String] = [String](newValue)
            _ = self.taskDictionary?.updateValue(assigneesArray, forKey: CreateTaskKeys.assignees)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.setupTableView()
        self.setupCoreData()
        self.fetchData()
    }
    
    private func setupCoreData() {
        let fetchRequest: NSFetchRequest<User> = User.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        // TODO: Needs team predicate
        
        fetchRequest.sortDescriptors = [sort]
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchData() {
        
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        // TODO: Remove hardcoded team id
        TeamService.getTeamMembers(teamId: "58b080b2356e913f3a3af182", offset: 0, success: { (teamMembers) in
            CoreDataStack.shared.saveContext()
            
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print("fetched results controller error: \(error)")
            }
            
        }) { (error, statusCode) in
            // TODO: Handle failure
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            print("dismissing!")
            guard let previousViewController: CreateTaskDateViewController = NavigationManager.getPreviousViewController(CreateTaskDateViewController.self, from: self) as? CreateTaskDateViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        } else {
            print("not dismissing!")
        }
    }
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: (self.assignDescriptionLabel.frame.origin.y + self.assignDescriptionLabel.frame.height), width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [createTaskBackgroundColor.cgColor, createTaskBackgroundColor.withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        self.view.backgroundColor = createTaskBackgroundColor
    }
    
    private func setupTableView() {
        let cell: UINib = UINib(nibName: "CreateTaskAssignCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "assignCell")
        self.tableView.rowHeight = 58
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = self.view.backgroundColor
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "updates", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskUpdatesViewController else { return }
        toVC.taskDictionary = dictionary
    }

}

extension CreateTaskAssignViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignCell", for: indexPath) as! CreateTaskAssignCell
        
        let teamMember = self.fetchedResultsController.object(at: indexPath)
        cell.load(teamMember)
        
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        cell.delegate = self
        if self.assignees.contains(teamMember.objectId) {
            cell.state = .selected
        }
        return cell
    }
}

extension CreateTaskAssignViewController: CreateTaskAssignCellDelegate {
    
    func selectedAssignCell(_ cell: CreateTaskAssignCell) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        _ = indexPath
        let user: String = self.fetchedResultsController.object(at: indexPath).objectId
        if self.assignees.contains(user) {
            self.assignees.remove(user)
        } else {
            self.assignees.insert(user)
        }
    }
}
