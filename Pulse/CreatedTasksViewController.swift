//
//  CreatedTasksViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class CreatedTasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsControllers: [NSFetchedResultsController<NSFetchRequestResult>] = [NSFetchedResultsController<NSFetchRequestResult>]()
    let headerStatus: [TaskStatus] = [.pending, .inProgress, .completed]
    var taskInvitationsFetchedResultsController: NSFetchedResultsController<TaskInvitation>!
    var tasksInProgressFetchedResultsController: NSFetchedResultsController<Task>!
    var tasksCompletedFetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupCoreData()
        self.fetchData()
    }
    
    private func setupCoreData() {
        // Reset FRC array
        self.fetchedResultsControllers.removeAll()
        
        // Setup Invitation FRC
        let invitationsFetchRequest: NSFetchRequest<TaskInvitation> = TaskInvitation.createFetchRequest()
        let statusPredicate = NSPredicate(format: "status == %@", "pending")
        let senderPredicate = NSPredicate(format: "sender.objectId == %@", User.currentUserId())
        let invitationsPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, senderPredicate])
        self.taskInvitationsFetchedResultsController = self.setupCoreData(with: invitationsFetchRequest, and: invitationsPredicate)
        
        let assigneePredicate: NSPredicate = NSPredicate(format: "assigner.objectId == %@", User.currentUserId())
        
        // Setup InProgress FRC
        let inProgressFetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let inProgressPredicate = NSPredicate(format: "status == %@", "in_progress")
        let inProgressCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inProgressPredicate, assigneePredicate])
        self.tasksInProgressFetchedResultsController = self.setupCoreData(with: inProgressFetchRequest, and: inProgressCompoundPredicate)
        
        // Setup Completed FRC
        let completedFetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let completedPredicate = NSPredicate(format: "status == %@", "completed")
        let completedCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [completedPredicate, assigneePredicate])
        self.tasksCompletedFetchedResultsController = self.setupCoreData(with: completedFetchRequest, and: completedCompoundPredicate)
        
        self.setupDatasource()
    }
    
    private func setupDatasource() {
        guard let resultsControllerOne: NSFetchedResultsController<NSFetchRequestResult> = self.taskInvitationsFetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult> else { return }
        guard let resultsControllerTwo: NSFetchedResultsController<NSFetchRequestResult> = self.tasksInProgressFetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult> else { return }
        guard let resultsControllerThree: NSFetchedResultsController<NSFetchRequestResult> = self.tasksCompletedFetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult> else { return }
        self.fetchedResultsControllers = [resultsControllerOne, resultsControllerTwo, resultsControllerThree]
    }
    
    private func setupCoreData<U>(with request: NSFetchRequest<U>, and predicate: NSPredicate) -> NSFetchedResultsController<U> {
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        request.predicate = predicate
        let controller: NSFetchedResultsController<U> = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
        return controller
    }
    
    private func fetchData() {
        self.checkCache()
        TaskService.getTasksCreated(success: {
            // If this is not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.fetchedResultsControllers.forEach({ controller in
                controller.delegate = nil
            })
            CoreDataStack.shared.saveContext()
            self.checkCache()
        }) { (error, statusCode) in
            print("Error getting tasks: \(statusCode) \(error.localizedDescription)")
        }
    }
    
    private func checkCache() {
        for controller in self.fetchedResultsControllers {
            // Check cache
            do {
                try controller.performFetch()
                controller.delegate = self
            } catch {
                print("Fetched results controller error: \(error)")
            }
        }
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "taskCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = mainBackgroundColor
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension CreatedTasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsControllers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsControllers[section].fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        let item: Any = self.fetchedResultsControllers[indexPath.section].object(at: indexPath.modify())
        cell.load(item, type: .assignee)
        return cell
    }
}

extension CreatedTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let sender: Any = self.fetchedResultsControllers[indexPath.section].object(at: indexPath.modify())
        taskVC.performSegue(withIdentifier: "editTask", sender: sender)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let fetchedObjects = self.fetchedResultsControllers[section].fetchedObjects else { return nil }
        if fetchedObjects.count > 0 {
            guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
            header.contentView.backgroundColor = self.tableView.backgroundColor
            header.load(status: self.headerStatus[section], type: .assigner)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let fetchedObjects = self.fetchedResultsControllers[section].fetchedObjects else {
            return 0
        }
        if fetchedObjects.count != 0 {
            return 30
        } else {
            return 0
        }
    }
}

extension CreatedTasksViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard var indexPath: IndexPath = indexPath else { return }
        guard let indexSection: Int = self.fetchedResultsControllers.index(of: controller) else { return }
        indexPath.section = indexSection
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [indexPath], with: .fade)
            
        case .delete:
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .update:
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell {
                cell.load(anObject, type: .assignee)
            }
            
        case .move:
            guard var newIndexPath: IndexPath = newIndexPath else { return }
            newIndexPath.section = indexSection
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
