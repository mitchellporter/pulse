//
//  CreateTaskAssignViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class CreateTaskAssignViewController: CreateTask {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var assignDescriptionLabel: UILabel!
    var taskDictionary: [CreateTaskKeys : [Any]]?
    var tableViewTopInset: CGFloat = 42
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    var assignees: Set<User> {
        get {
            guard let assignees: [User] = self.taskDictionary?[.assignees] as? [User] else { return Set<User>() }
            let set = Set<User>(assignees)
            return set
        }
        set {
            let assigneesArray: [User] = [User](newValue)
            _ = self.taskDictionary?.updateValue(assigneesArray, forKey: CreateTaskKeys.assignees)
            self.nextButtonToggle()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
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
            guard let previousViewController: CreateTaskDateViewController = NavigationManager.getPreviousViewController(CreateTaskDateViewController.self, from: self) as? CreateTaskDateViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        }
    }
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: (self.tableView.frame.origin.y), width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [createTaskBackgroundColor.cgColor, createTaskBackgroundColor.withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        self.view.backgroundColor = createTaskBackgroundColor
        
        self.nextButtonToggle()
    }
    
    private func nextButtonToggle() {
        let nextAlpha: CGFloat = self.assignees.count > 0 ? 1.0 : 0.0
        UIView.animate(withDuration: 0.1, animations: {
            self.nextButton.alpha = nextAlpha
        })
    }
    
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "CreateTaskAssignCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "assignCell")
        self.tableView.rowHeight = 58
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.showsVerticalScrollIndicator = false
    }
    
    private func create(task: [CreateTaskKeys:[Any]]) {
        guard let description: String = task[.description]?.first as? String else { return }
        guard let items: [String] = task[.items] as? [String] else { return }
        guard let assignees: [User] = task[.assignees] as? [User] else { return }
        var members: [String] = [String]()
        for member in assignees {
            members.append(member.objectId)
        }
        let dueDate: Date? = task[.dueDate]?.first as? Date
        let updateInterval: [WeekDay] = task[.updateInterval] == nil ? [WeekDay]() : task[.updateInterval]! as! [WeekDay]
        TaskService.createTask(title: description, items: items, assignees: members, dueDate: dueDate, updateDays: updateInterval, success: { (task) in
            // Successfully created task
            // Do Something
            
            self.performSegue(withIdentifier: "completeCreateTask", sender: nil)
        }) { (error, statusCode) in
            // TODO: Handle Error
            print("There was an error when creating the task. Error: \(statusCode) \(error.localizedDescription)")
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
        guard let task: Dictionary<CreateTaskKeys,[Any]> = self.taskDictionary else { print("No task dictionary on CreateTaskAssignController"); return }
        self.create(task: task)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskUpdatesViewController else { return }
        toVC.taskDictionary = dictionary
    }

}

extension CreateTaskAssignViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 36
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        header.contentView.backgroundColor = createTaskBackgroundColor
        header.title = "MY TEAM"
        header.markerWidth = 5.0
        return header
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
        if self.assignees.contains(teamMember) {
            cell.state = .selected
        }
        return cell
    }
}

extension CreateTaskAssignViewController: CreateTaskAssignCellDelegate {
    
    func selectedAssignCell(_ cell: CreateTaskAssignCell) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        _ = indexPath
        let user: User = self.fetchedResultsController.object(at: indexPath)
        if self.assignees.contains(user) {
            self.assignees.remove(user)
        } else {
            self.assignees.insert(user)
        }
    }
}
