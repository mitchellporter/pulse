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
        
        // Notes: If you don't specify a sectionNameKeyPath for this FRC, but the other one has one, then this one will cause errors in the FRC delegate methods.
        // Here's the specific problem I kept running into:
        // On first run, I was making sure that we had in_progress tasks, completed tasks, and NO invites. This worked fine.
        // I then modified the backend to make an invite, so now we needed 3 total sections with both controllers vs. just using the task controller and having 2 sections
        // This was causing update errors because I was manually calculating the sections count for the tableview to 3, but the task invite FRC had no context of "sections" because I wasn't setting a sectionNameKeyPath on it.
        // So the FRC delegate's "did change an object" method was getting called, but the "did change section info" was not. Because it wasn't being called, we couldn't insert an additional section...
        // so the calculated section value of 3 wasn't matching up to the total section count as a result of all my frc delegate method implementations, and the counts need to match. I fixed this by setting a sectionNameKeyPath on the task invite FRC.
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
        var sectionCount = 0
        if let fetchedObjects = self.assigneeUpdatesFetchedResultsController.fetchedObjects {
            sectionCount += fetchedObjects.count != 0 ? 1 : 0
        }
        if let fetchedObjects = self.assignerUpdatesFetchedResultsController.fetchedObjects {
            sectionCount += fetchedObjects.count != 0 ? 1 : 0
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let fetchedObjects = self.assigneeUpdatesFetchedResultsController.fetchedObjects {
                return fetchedObjects.count
            }
            return self.assignerUpdatesFetchedResultsController.fetchedObjects?.count ?? 0
        } else {
            return self.assignerUpdatesFetchedResultsController.fetchedObjects?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        
        var update: Update
        if indexPath.section == 0 {
            if self.assigneeUpdatesFetchedResultsController.fetchedObjects != nil {
                update = self.assigneeUpdatesFetchedResultsController.object(at: indexPath)
            } else {
                update = self.assignerUpdatesFetchedResultsController.object(at: indexPath)
            }
        } else {
            let realIndexPath = IndexPath(row: indexPath.row, section: 0)
            update = self.assignerUpdatesFetchedResultsController.object(at: realIndexPath)
        }
        
        if let task: Task = update.task {
            cell.load(task: task, type: .assignee)
        }
        return cell
    }
}

extension UpdatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let segue: String = indexPath.section == 0 ? "giveUpdate" : "viewUpdate"
        
        var update: Update
        if indexPath.section == 0 {
            if self.assigneeUpdatesFetchedResultsController.fetchedObjects != nil {
                update = self.assigneeUpdatesFetchedResultsController.object(at: indexPath)
            } else {
                update = self.assignerUpdatesFetchedResultsController.object(at: indexPath)
            }
        } else {
            let realIndexPath = IndexPath(row: indexPath.row, section: 0)
            update = self.assignerUpdatesFetchedResultsController.object(at: realIndexPath)
        }
        taskVC.performSegue(withIdentifier: segue, sender: update)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        header.title = section == 0 ? "PROGRESS UPDATES I NEED TO COMPLETE" : "PROGRESS UPDATES SENT TO ME"
        header.markerColor = section == 0 ? appRed : appYellow
        header.contentView.backgroundColor = self.tableView.backgroundColor
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

extension UpdatesViewController: NSFetchedResultsControllerDelegate {
    
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
            if controller == self.assigneeUpdatesFetchedResultsController {
                self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            } else if controller == self.assignerUpdatesFetchedResultsController {
                
                var realIndexPath: IndexPath
                if (self.assigneeUpdatesFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section)
                }
                
                self.tableView.insertRows(at: [realIndexPath], with: .fade)
            }
        case .delete:
            
            if controller == self.assigneeUpdatesFetchedResultsController {
                // NOTE: Last row of section deletion bug fix: https://forums.developer.apple.com/thread/9964#26303
                if self.tableView.numberOfRows(inSection: indexPath!.section) == 1 {
                    self.tableView.deleteSections([indexPath!.section], with: .fade)
                } else {
                    self.tableView.deleteRows(at: [indexPath!], with: .fade)
                }
            } else if controller == self.assignerUpdatesFetchedResultsController {
                var realIndexPath: IndexPath
                if (self.assigneeUpdatesFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section)
                }
                // NOTE: Last row of section deletion bug fix: https://forums.developer.apple.com/thread/9964#26303
                if self.tableView.numberOfRows(inSection: realIndexPath.section) == 1 {
                    self.tableView.deleteSections([realIndexPath.section], with: .fade)
                } else {
                    self.tableView.deleteRows(at: [realIndexPath], with: .fade)
                }
            }
            
        case .update: // lots
            
            if controller == self.assigneeUpdatesFetchedResultsController {
                if let cell = self.tableView.cellForRow(at: indexPath!) as? UpdateCell {
                    
                    let update = self.assigneeUpdatesFetchedResultsController.fetchedObjects!.first!
                    cell.load(update: update, type: .assignee)
                }
            } else if controller == self.assignerUpdatesFetchedResultsController {
                var realIndexPath: IndexPath
                if (self.assigneeUpdatesFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section)
                }
                if let cell = self.tableView.cellForRow(at: realIndexPath) as? UpdateCell {
                    let update = anObject as! Update
                    cell.load(update: update, type: .assigner)
                }
            }
        case .move:
            
            
            if controller == self.assigneeUpdatesFetchedResultsController {
                self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
            } else if controller == self.assignerUpdatesFetchedResultsController {
                var realIndexPath: IndexPath
                if (self.assigneeUpdatesFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section)
                }
                
                // NOTE: Not 100% on this, may cause problems: http://stackoverflow.com/a/8072390/3344977
                let deleteIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section + 1)
                self.tableView.deleteRows(at: [deleteIndexPath], with: .fade)
                self.tableView.insertRows(at: [realIndexPath], with: .fade)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
