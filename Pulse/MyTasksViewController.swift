//
//  MyTasksViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class MyTasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskInvitationsFetchedResultsController: NSFetchedResultsController<TaskInvitation>!
    var tasksInProgressFetchedResultsController: NSFetchedResultsController<Task>!
    var tasksCompletedFetchedResultsController: NSFetchedResultsController<Task>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupTaskInvitationCoreData()
        self.setupTasksInProgressCoreData()
        self.setupTasksCompletedCoreData()
        self.fetchData()
    }
    
    private func setupTaskInvitationCoreData() {
        // Task invitations
        let fetchRequest: NSFetchRequest<TaskInvitation> = TaskInvitation.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        
        /// I ONLY WANT PENDING, NO ACCEPTED OR DENIED
        let predicate = NSPredicate(format: "receiver.objectId == %@ AND status == %@", User.currentUserId(), "pending")
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        
        self.taskInvitationsFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupTasksInProgressCoreData() {
        
        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        
        let inProgressPredicate = NSPredicate(format: "status == %@", "in_progress")
        let assigneePredicate = NSPredicate(format: "ANY assignees.objectId == %@", User.currentUserId())
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [inProgressPredicate, assigneePredicate])

        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.tasksInProgressFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupTasksCompletedCoreData() {

        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        
        let completedPredicate = NSPredicate(format: "status == %@", "completed")
        let assigneePredicate = NSPredicate(format: "ANY assignees.objectId == %@", User.currentUserId())
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [completedPredicate, assigneePredicate])
        
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.tasksCompletedFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchData() {
        
        // Check cache
        do {
            try self.taskInvitationsFetchedResultsController.performFetch()
            try self.tasksInProgressFetchedResultsController.performFetch()
            try self.tasksCompletedFetchedResultsController.performFetch()

            self.taskInvitationsFetchedResultsController.delegate = self
            self.tasksInProgressFetchedResultsController.delegate = self
            self.tasksCompletedFetchedResultsController.delegate = self

            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        TaskService.getMyTasks(success: {
            
            // If these are not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.taskInvitationsFetchedResultsController.delegate = nil
            self.tasksInProgressFetchedResultsController.delegate = nil
            self.tasksCompletedFetchedResultsController.delegate = nil

            CoreDataStack.shared.saveContext()
            
            do {
                try self.taskInvitationsFetchedResultsController.performFetch()
                try self.tasksInProgressFetchedResultsController.performFetch()
                try self.tasksCompletedFetchedResultsController.performFetch()

                self.taskInvitationsFetchedResultsController.delegate = self
                self.tasksInProgressFetchedResultsController.delegate = self
                self.tasksCompletedFetchedResultsController.delegate = self

                self.tableView.reloadData()
            } catch {
                print("fetched results controller error: \(error)")
            }

        }) { (error, statusCode) in
            // TODO: Handle failure
        }
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

    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        // Setup cell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "viewTask" {
            guard let toVC: ViewTaskViewController = segue.destination as? ViewTaskViewController else { return }
            
            if let task: Task = sender as? Task {
                toVC.task = task
            }
            
            if let taskInvite: TaskInvitation = sender as? TaskInvitation {
                toVC.taskInvite = taskInvite
            }
        }
    }
}

extension MyTasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 // TODO: Ref some type of frc count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.taskInvitationsFetchedResultsController.fetchedObjects?.count ?? 0
        case 1:
            return self.tasksInProgressFetchedResultsController.fetchedObjects?.count ?? 0
        case 2:
            return self.tasksCompletedFetchedResultsController.fetchedObjects?.count ?? 0
        default: return 0 // TODO: Handle
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        
        switch indexPath.section {
        case 0:
            let taskInvitation: TaskInvitation = self.taskInvitationsFetchedResultsController.object(at: indexPath.modify())
            cell.load(invitation: taskInvitation, type: .assignee)
            return cell
        case 1:
            let task = self.tasksInProgressFetchedResultsController.object(at: indexPath.modify())
            cell.load(task: task, type: .assignee)
            return cell
        case 2:
            let task = self.tasksCompletedFetchedResultsController.object(at: indexPath.modify())
            cell.load(task: task, type: .assignee)
            return cell
        default: return UITableViewCell() // TODO: Handle
        }
    }
}

extension MyTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        var sender: Any?
        
        switch indexPath.section {
        case 0:
            sender = self.taskInvitationsFetchedResultsController.object(at: indexPath.modify())
        case 1:
            sender = self.tasksInProgressFetchedResultsController.object(at: indexPath.modify())
        case 2:
            sender = self.tasksCompletedFetchedResultsController.object(at: indexPath.modify())
        default: break
        }
        taskVC.performSegue(withIdentifier: "viewTask", sender: sender)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        
        switch section {
        case 0:
            header.load(status: .pending, type: .assignee)
        case 1:
            header.load(status: .inProgress, type: .assignee)

        case 2:
            header.load(status: .completed, type: .assignee)
        default: break
        }
        
        header.contentView.backgroundColor = self.tableView.backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}

extension MyTasksViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
 
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            switch controller {
            case self.taskInvitationsFetchedResultsController:
                self.tableView.insertRows(at: [newIndexPath!.taskInvitationIndexPath()], with: .fade)
            case self.tasksInProgressFetchedResultsController:
                self.tableView.insertRows(at: [newIndexPath!.taskInProgressIndexPath()], with: .fade)
            case self.tasksCompletedFetchedResultsController:
                self.tableView.insertRows(at: [newIndexPath!.taskCompletedIndexPath()], with: .fade)
            default: break
            }
            
        case .delete:
            
            switch controller {
            case self.taskInvitationsFetchedResultsController:
                self.tableView.deleteRows(at: [indexPath!.taskInvitationIndexPath()], with: .fade)
            case self.tasksInProgressFetchedResultsController:
                self.tableView.deleteRows(at: [indexPath!.taskInProgressIndexPath()], with: .fade)
            case self.tasksCompletedFetchedResultsController:
                self.tableView.deleteRows(at: [indexPath!.taskCompletedIndexPath()], with: .fade)
            default: break
            }
        
        case .update:
            
            guard let indexPath = indexPath else { return }
            switch controller {
            case self.taskInvitationsFetchedResultsController:
                if let cell = self.tableView.cellForRow(at: indexPath.taskInvitationIndexPath()) as? TaskCell {
                    let taskInvitation = anObject as! TaskInvitation
                    cell.load(invitation: taskInvitation, type: .assignee)
                }
                
            case self.tasksInProgressFetchedResultsController:
                if let cell = self.tableView.cellForRow(at: indexPath.taskInProgressIndexPath()) as? TaskCell {
                    let task = anObject as! Task
                    cell.load(task: task, type: .assignee)
                }
                
            case self.tasksCompletedFetchedResultsController:
                if let cell = self.tableView.cellForRow(at: indexPath.taskCompletedIndexPath()) as? TaskCell {
                    let task = anObject as! Task
                    cell.load(task: task, type: .assignee)
                }
            default: break
            }
            
        case .move:
            
            switch controller {
            case self.taskInvitationsFetchedResultsController:
                self.tableView.moveRow(at: indexPath!.taskInvitationIndexPath(), to: newIndexPath!.taskInvitationIndexPath())
            case self.tasksInProgressFetchedResultsController:
                self.tableView.moveRow(at: indexPath!.taskInProgressIndexPath(), to: newIndexPath!.taskInProgressIndexPath())
            case self.tasksCompletedFetchedResultsController:
                self.tableView.moveRow(at: indexPath!.taskInProgressIndexPath(), to: newIndexPath!.taskCompletedIndexPath())
            default: break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension IndexPath {
    
    // Every frc only has a concept of 1 section aka section 0 - despite the fact that the table has 3 sections
    // Converting from tableview to FRC section space
    func modify() -> IndexPath {
        return IndexPath(row: self.row, section: 0)
    }
    
    // Converting from FRC to tableview section space
    func taskInvitationIndexPath() -> IndexPath {
        return IndexPath(row: self.row, section: 0)
    }
    
    func taskInProgressIndexPath() -> IndexPath {
        return IndexPath(row: self.row, section: 1)
    }
    
    func taskCompletedIndexPath() -> IndexPath {
        return IndexPath(row: self.row, section: 2)
    }
}
