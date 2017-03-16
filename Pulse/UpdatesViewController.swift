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
    var updateFetchedResultsController: NSFetchedResultsController<Update>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupCoreData()
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
    
    private func setupCoreData() {
        // Task invitations
        let fetchRequest: NSFetchRequest<Update> = Update.createFetchRequest()
        let sort = NSSortDescriptor(key: "taskAssignerIsCurrentUser", ascending: false)
        
//        let pred1 = NSPredicate(format: "ANY responses.assignee.objectId == %@", User.currentUserId())
//        let predicate = NSPredicate(format: "receiver.objectId == %@ AND status == %@", User.currentUserId(), "sent")
        
        fetchRequest.sortDescriptors = [sort]
//        fetchRequest.predicate = predicate
        
        // Notes: If you don't specify a sectionNameKeyPath for this FRC, but the other one has one, then this one will cause errors in the FRC delegate methods.
        // Here's the specific problem I kept running into:
        // On first run, I was making sure that we had in_progress tasks, completed tasks, and NO invites. This worked fine.
        // I then modified the backend to make an invite, so now we needed 3 total sections with both controllers vs. just using the task controller and having 2 sections
        // This was causing update errors because I was manually calculating the sections count for the tableview to 3, but the task invite FRC had no context of "sections" because I wasn't setting a sectionNameKeyPath on it.
        // So the FRC delegate's "did change an object" method was getting called, but the "did change section info" was not. Because it wasn't being called, we couldn't insert an additional section...
        // so the calculated section value of 3 wasn't matching up to the total section count as a result of all my frc delegate method implementations, and the counts need to match. I fixed this by setting a sectionNameKeyPath on the task invite FRC.
        self.updateFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchData() {
        
     
        
        // Check cache
        do {
            try self.updateFetchedResultsController.performFetch()
            self.updateFetchedResultsController.delegate = self
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        FeedService.getUpdatesFeed(success: { (updates) in
            // NOTE: If these are not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.updateFetchedResultsController.delegate = nil
            
            CoreDataStack.shared.saveContext()
            
            do {
                try self.updateFetchedResultsController.performFetch()
                self.updateFetchedResultsController.delegate = self
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
        let sectionInfo = self.updateFetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
            let update = self.updateFetchedResultsController.object(at: indexPath)
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
        let sender: Update = self.updateFetchedResultsController.object(at: indexPath)
        taskVC.performSegue(withIdentifier: segue, sender: sender)
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
        
        // If the controller is the invitation controller, then just use the section Index like normal
        
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
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update: // lots
            if let cell = self.tableView.cellForRow(at: indexPath!) as? TaskCell {
                let update = self.updateFetchedResultsController.object(at: indexPath!)
                cell.load(task: update.task!, type: .assigner)
            }
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}

