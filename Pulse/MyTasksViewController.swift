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
    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupCoreData()
        self.fetchData()
    }
    
    private func setupCoreData() {
        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let predicate = NSPredicate(format: "ANY assignees.objectId == %@", User.currentUserId())
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "status", cacheName: nil)
    }
    
    private func fetchData() {
        
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        
        
        TaskService.getTasksAssignedToUser(assigneeId: User.currentUserId(), offset: 0, success: { (tasks) in
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
        
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "taskCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = mainBackgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        // Setup cell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
    }
}

extension MyTasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        let task = self.fetchedResultsController.object(at: indexPath)
        cell.load(task: task, type: .assignee)
        
        return cell
    }
}

extension MyTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let task = self.fetchedResultsController.object(at: indexPath)
        taskVC.performSegue(withIdentifier: "viewTask", sender: task)
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
    
    /*
     Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
     subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
     with information from a managed object at the given index path in the fetched results controller.
     */
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch(type) {
        case .insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
            
        case .delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        let tableView: UITableView = self.tableView
        guard let indexPath: IndexPath = indexPath else { return }
        switch(type) {
            
        case .insert:
            tableView.insertRows(at: [indexPath], with: .fade)
            break
            
        case .delete:
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
            
        case .update:
            guard let cell: UITableViewCell = self.tableView.cellForRow(at: indexPath) else { break }
            self.configure(cell: cell, at: indexPath)
            break
            
        case .move:
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.insertRows(at: [indexPath], with: .fade)
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
