//
//  TeamMemberViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/29/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import Nuke
import CoreData

class TeamMemberViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var inProgressButton: UIButton!
    @IBOutlet weak var createdTasksButton: UIButton!
    
    var user: User?
    fileprivate var assignedFetchedResultsController: NSFetchedResultsController<Task>!
    fileprivate var createdFetchedResultsController: NSFetchedResultsController<Task>!
    private var marker: UIImageView = UIImageView(image: #imageLiteral(resourceName: "GreenCircleMarker"))
    
    fileprivate var selectedSection: Int = 0 {
        didSet {
            if self.assignedFetchedResultsController != nil && self.createdFetchedResultsController != nil {
                self.fetchData(in: self.selectedSection)
                self.updateButtonSelection()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let user: User = self.user else { return }
        self.load(user: user)
    }
    
    private func setupAppearance() {
        self.avatarImageView.layer.cornerRadius = 7
        self.marker.frame.origin = CGPoint(x: 25, y: 26)
    }
    
    private func load(user: User) {
        self.nameLabel.text = user.name
        self.positionLabel.text = user.position
        
        guard let avatarURL: URL = URL(string: user.avatarURL ?? "") else { return }
        Nuke.loadImage(with: avatarURL, into: self.avatarImageView)
        self.setupCoreData(with: user)
        self.fetchData(in: self.selectedSection)
        self.selectedSection = 0
    }
    
    private func setupTableView() {
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "taskCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.backgroundColor = UIColor("ECEFF1")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 124
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    private func setupCoreData(with user: User) {
        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let assigneePredicate = NSPredicate(format: "ANY assignees.objectId == %@", user.objectId)
        let inProgressPredicate: NSPredicate = NSPredicate(format: "status == %@", "in_progress")
        let compoundPredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [assigneePredicate, inProgressPredicate])
        fetchRequest.predicate = compoundPredicate
        let fetchedResultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        self.assignedFetchedResultsController = fetchedResultsController
        
        let createdFetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        createdFetchRequest.sortDescriptors = [sortDescriptor]
        let createdPredicate = NSPredicate(format: "assigner.objectId == %@", user.objectId)
        let createdCompoundPredicate: NSCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [createdPredicate, inProgressPredicate])
        createdFetchRequest.predicate = createdCompoundPredicate
        let createdFetchedResultsController: NSFetchedResultsController<Task> = NSFetchedResultsController(fetchRequest: createdFetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        self.createdFetchedResultsController = createdFetchedResultsController
    }
    
    private func fetchData(in section: Int) {
        let resultsController: NSFetchedResultsController<NSManagedObject> = section == 0 ? self.assignedFetchedResultsController as! NSFetchedResultsController<NSManagedObject> : self.createdFetchedResultsController as! NSFetchedResultsController<NSManagedObject>
        
        self.checkCache(resultsController)
        guard let user: User = self.user else { return }
        if selectedSection == 0 {
            TaskService.getTasksAssignedToUser(assigneeId: user.objectId, offset: 0, success: { (tasks) in
                self.assignedFetchedResultsController.delegate = nil
                CoreDataStack.shared.saveContext()
                
                self.checkCache(resultsController)
            }) { (error, statusCode) in
                print("Error getting tasks: \(statusCode ?? 000) \(error.localizedDescription)")
            }
        } else if selectedSection == 1 {
            TaskService.getTasksCreatedByUser(assignerId: user.objectId, offset: 0, success: { (tasks) in
                self.createdFetchedResultsController.delegate = nil
                CoreDataStack.shared.saveContext()
                
                self.checkCache(resultsController)
            }, failure: { (error, statusCode) in
                print("Error getting tasks: \(statusCode ?? 000) \(error.localizedDescription)")
            })
        }
    }
    
    private func checkCache(_ resultsController: NSFetchedResultsController<NSManagedObject>) {
        // Check cache
        do {
            try resultsController.performFetch()
            resultsController.delegate = self
        } catch {
            print("Fetched results controller error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    private func updateButtonSelection() {
        if self.selectedSection == 0 {
            self.inProgressButton.addSubview(self.marker)
            self.inProgressButton.titleLabel?.textColor = UIColor("636363")
            
            self.createdTasksButton.titleLabel?.textColor = UIColor("C4C4C4")
        } else if self.selectedSection == 1 {
            self.createdTasksButton.addSubview(self.marker)
            self.createdTasksButton.titleLabel?.textColor = UIColor("636363")
            
            self.inProgressButton.titleLabel?.textColor = UIColor("C4C4C4")
        }
    }
    
    @IBAction func assignedTasksButtonPressed(_ sender: UIButton) {
        self.selectedSection = 0
    }
    
    @IBAction func createdTasksButtonPressed(_ sender: UIButton) {
        self.selectedSection = 1
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "viewTask" {
            guard let task: Task = sender as? Task else { return }
            guard let destinationVC: ViewTeamMemberTaskViewController = segue.destination as? ViewTeamMemberTaskViewController else { return }
            destinationVC.task = task
        }
    }
}

extension TeamMemberViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedSection == 0 {
            return self.assignedFetchedResultsController.sections?.count ?? 0
        } else if self.selectedSection == 1 {
            return self.createdFetchedResultsController.sections?.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedSection == 0 {
            return self.assignedFetchedResultsController.sections?[section].numberOfObjects ?? 0
        } else if self.selectedSection == 1 {
            return self.createdFetchedResultsController.sections?[section].numberOfObjects ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        if self.selectedSection == 0 {
            guard let item: Task = self.assignedFetchedResultsController.sections?[indexPath.section].objects?[indexPath.row] as? Task else { return cell }
            cell.load(item, type: .myTask)
        } else if self.selectedSection == 1 {
            guard let item: Task = self.createdFetchedResultsController.sections?[indexPath.section].objects?[indexPath.row] as? Task else { return cell }
            cell.load(item, type: .createdTask)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sender: Any = self.assignedFetchedResultsController.sections?[indexPath.section].objects?[indexPath.row] else { return }
        self.performSegue(withIdentifier: "viewTask", sender: sender)
    }
}

extension TeamMemberViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            self.tableView.deleteSections([sectionIndex], with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath: IndexPath = newIndexPath else { return }
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath: IndexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath: IndexPath = indexPath else { return }
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell {
                cell.load(anObject, type: .createdTask)
            }
        case .move:
            guard let indexPath: IndexPath = indexPath else { return }
            guard let newIndexPath: IndexPath = newIndexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
