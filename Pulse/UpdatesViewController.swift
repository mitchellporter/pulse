//
//  UpdatesViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class UpdatesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var assigneeUpdatesFetchedResultsController: NSFetchedResultsController<Update>!
    var assignerUpdatesFetchedResultsController: NSFetchedResultsController<Update>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupAssigneeCoreData()
        self.setupAssignerCoreData()
        self.fetchData()
    }
    
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        let taskCell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "UpdateRequestCell")
        self.tableView.register(taskCell, forCellReuseIdentifier: "TaskCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = mainBackgroundColor
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setupAssigneeCoreData() {
        let fetchRequest: NSFetchRequest<Update> = Update.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)

        let requiresResponsePredicate = NSPredicate(format: "requiresResponseFromCurrentUser == true")
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = requiresResponsePredicate
        
        self.assigneeUpdatesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func setupAssignerCoreData() {
        let fetchRequest: NSFetchRequest<Update> = Update.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        
        let taskAssignerPredicate = NSPredicate(format: "task.assigner.objectId == %@", User.currentUserId())
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = taskAssignerPredicate
        
        self.assignerUpdatesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchData() {
        
        // Check cache
        do {
            try self.assigneeUpdatesFetchedResultsController.performFetch()
            try self.assignerUpdatesFetchedResultsController.performFetch()

            self.assigneeUpdatesFetchedResultsController.delegate = self
            self.assignerUpdatesFetchedResultsController.delegate = self

            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        FeedService.getUpdatesFeed(success: { (updates) in
            // NOTE: If these are not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.assigneeUpdatesFetchedResultsController.delegate = nil
            self.assignerUpdatesFetchedResultsController.delegate = nil
            
            CoreDataStack.shared.saveContext()
            
            do {
                try self.assigneeUpdatesFetchedResultsController.performFetch()
                try self.assignerUpdatesFetchedResultsController.performFetch()
                
                self.assigneeUpdatesFetchedResultsController.delegate = self
                self.assignerUpdatesFetchedResultsController.delegate = self
                
                self.tableView.reloadData()
            } catch {
                print("fetched results controller error: \(error)")
            }
        }) { (error, statusCode) in
            // TODO: Handle error
        }
    }

    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        // Setup cell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
    }
}

extension UpdatesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.assigneeUpdatesFetchedResultsController.fetchedObjects?.count ?? 0
        case 1:
            return self.assignerUpdatesFetchedResultsController.fetchedObjects?.count ?? 0
        default: return 0 // TODO: Handle
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        
        switch indexPath.section {
        case 0:
            let update: Update = self.assigneeUpdatesFetchedResultsController.object(at: indexPath.modify())
            cell.load(task: update.task!, type: .assignee)
            return cell
        case 1:
            let update: Update = self.assignerUpdatesFetchedResultsController.object(at: indexPath.modify())
            cell.load(task: update.task!, type: .assigner)
            return cell
        default: return UITableViewCell() // TODO: Handle
        }
    }
}

extension UpdatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let segue: String = indexPath.section == 0 ? "giveUpdate" : "viewUpdate"
        
        var update: Update?
        switch indexPath.section {
        case 0:
            update = self.assigneeUpdatesFetchedResultsController.object(at: indexPath.modify())
        case 1:
            update = self.assignerUpdatesFetchedResultsController.object(at: indexPath.modify())
        default: break
        }
        taskVC.performSegue(withIdentifier: segue, sender: update!)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        
        switch section {
        case 0:
            
            guard let fetchedObjects = self.assigneeUpdatesFetchedResultsController.fetchedObjects else {
                return nil
            }
            if fetchedObjects.count != 0 {
                header.title = section == 0 ? "PROGRESS UPDATES I NEED TO COMPLETE" : "PROGRESS UPDATES SENT TO ME"
                header.markerColor = section == 0 ? appRed : appYellow
                header.contentView.backgroundColor = self.tableView.backgroundColor
                return header
            } else {
                return nil
            }
            
        case 1:
            
            guard let fetchedObjects = self.assignerUpdatesFetchedResultsController.fetchedObjects else {
                return nil
            }
            if fetchedObjects.count != 0 {
                header.title = section == 0 ? "PROGRESS UPDATES I NEED TO COMPLETE" : "PROGRESS UPDATES SENT TO ME"
                header.markerColor = section == 0 ? appRed : appYellow
                header.contentView.backgroundColor = self.tableView.backgroundColor
                return header
            } else {
                return nil
            }
            
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            
            guard let fetchedObjects = self.assigneeUpdatesFetchedResultsController.fetchedObjects else {
                return 0
            }
            if fetchedObjects.count != 0 {
                return 30
            } else {
                return 0
            }
            
        case 1:
            
            guard let fetchedObjects = self.assignerUpdatesFetchedResultsController.fetchedObjects else {
                return 0
            }
            if fetchedObjects.count != 0 {
                return 30
            } else {
                return 0
            }
        default: return 0
        }
    }
}

extension UpdatesViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            
            switch controller {
            case self.assigneeUpdatesFetchedResultsController:
                self.tableView.insertRows(at: [newIndexPath!.updatesAssigneeIndexPath()], with: .fade)
            case self.assignerUpdatesFetchedResultsController:
                self.tableView.insertRows(at: [newIndexPath!.updatesAssignerIndexPath()], with: .fade)
            default: break
            }
            
        case .delete:
            
            switch controller {
            case self.assigneeUpdatesFetchedResultsController:
                self.tableView.deleteRows(at: [indexPath!.updatesAssigneeIndexPath()], with: .fade)
            case self.assignerUpdatesFetchedResultsController:
                self.tableView.deleteRows(at: [indexPath!.updatesAssignerIndexPath()], with: .fade)
            default: break
            }
            
        case .update:
            
            guard let indexPath = indexPath else { return }
            switch controller {
            case self.assigneeUpdatesFetchedResultsController:
                if let cell = self.tableView.cellForRow(at: indexPath.updatesAssigneeIndexPath()) as? TaskCell {
                    let update = anObject as! Update
                    cell.load(task: update.task!, type: .assignee)
                }
                
            case self.assignerUpdatesFetchedResultsController:
                if let cell = self.tableView.cellForRow(at: indexPath.updatesAssignerIndexPath()) as? TaskCell {
                    let update = anObject as! Update
                    cell.load(task: update.task!, type: .assigner)
                }
            default: break
            }
            
        case .move:
            
            switch controller {
            case self.assigneeUpdatesFetchedResultsController:
                self.tableView.moveRow(at: indexPath!.updatesAssigneeIndexPath(), to: newIndexPath!.updatesAssigneeIndexPath())
                
            case self.assignerUpdatesFetchedResultsController:
                self.tableView.moveRow(at: indexPath!.updatesAssignerIndexPath(), to: newIndexPath!.updatesAssignerIndexPath())
            default: break
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

extension IndexPath {
    
    // Converting from FRC to tableview section space
    func updatesAssigneeIndexPath() -> IndexPath {
        return IndexPath(row: self.row, section: 0)
    }
    
    func updatesAssignerIndexPath() -> IndexPath {
        return IndexPath(row: self.row, section: 1)
    }
}
