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
    var updateRequestFetchedResultsController: NSFetchedResultsController<UpdateRequest>!
    var taskFetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupUpdateRequestCoreData()
        self.setupTaskCoreData()
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
    
    private func setupUpdateRequestCoreData() {
        // Task invitations
        let fetchRequest: NSFetchRequest<UpdateRequest> = UpdateRequest.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let predicate = NSPredicate(format: "receiver.objectId == %@", User.currentUserId())
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        
        // Notes: If you don't specify a sectionNameKeyPath for this FRC, but the other one has one, then this one will cause errors in the FRC delegate methods.
        // Here's the specific problem I kept running into:
        // On first run, I was making sure that we had in_progress tasks, completed tasks, and NO invites. This worked fine.
        // I then modified the backend to make an invite, so now we needed 3 total sections with both controllers vs. just using the task controller and having 2 sections
        // This was causing update errors because I was manually calculating the sections count for the tableview to 3, but the task invite FRC had no context of "sections" because I wasn't setting a sectionNameKeyPath on it.
        // So the FRC delegate's "did change an object" method was getting called, but the "did change section info" was not. Because it wasn't being called, we couldn't insert an additional section...
        // so the calculated section value of 3 wasn't matching up to the total section count as a result of all my frc delegate method implementations, and the counts need to match. I fixed this by setting a sectionNameKeyPath on the task invite FRC.
        self.updateRequestFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        //        self.taskInvitationFetchedResultsController.delegate = self
        //        print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
        
    }
    
    private func setupTaskCoreData() {
        // Tasks
        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let predicate = NSPredicate(format: "assigner.objectId == %@", User.currentUserId())
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.taskFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        //        self.taskFetchedResultsController.delegate = self
        
        //        print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
        
    }
    
    private func fetchData() {
        
        //        print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
        //        print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
        
        // Check cache
        do {
            try self.updateRequestFetchedResultsController.performFetch()
            try self.taskFetchedResultsController.performFetch()
            
            //            print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections![0].numberOfObjects)")
            //            print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
            
//            self.updateRequestFetchedResultsController.delegate = self
//            self.taskFetchedResultsController.delegate = self
            
            
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        TaskService.getUpdatesFeed(success: {
            
            // If these are not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.updateRequestFetchedResultsController.delegate = nil
            self.taskFetchedResultsController.delegate = nil
            
            CoreDataStack.shared.saveContext()
            
            //            print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
            //            print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
            
            
            
            do {
                try self.updateRequestFetchedResultsController.performFetch()
                try self.taskFetchedResultsController.performFetch()
                
//                self.updateRequestFetchedResultsController.delegate = self
//                self.taskFetchedResultsController.delegate = self
                
                
                //                print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
                //                print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
                
                
                //                print("task sections: \(self.taskFetchedResultsController.sections?.count ?? 1)")
                //                print("first section info: \(self.taskFetchedResultsController.sections![0].name)")
                //                print("second section info: \(self.taskFetchedResultsController.sections![1].name)")
                //                print("first section objects count: \(self.taskFetchedResultsController.sections![0].numberOfObjects)")
                //                print("second section objects count: \(self.taskFetchedResultsController.sections![1].numberOfObjects)")
                
                
                self.tableView.reloadData()
            } catch {
                print("fetched results controller error: \(error)")
            }
            
        }) { (error, statusCode) in
            // TODO: Handle failure
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
        if section == 0 {
            let sectionInfo = self.updateRequestFetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        } else {
            let sectionInfo = self.taskFetchedResultsController.sections![section - 1]
            return sectionInfo.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let realIndex: IndexPath = indexPath.section == 0 ? indexPath : IndexPath(row: indexPath.row, section: indexPath.section - 1)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        if indexPath.section == 0 {
            let updateRequest = self.updateRequestFetchedResultsController.object(at: indexPath)
            if let task: Task = updateRequest.task {
                cell.load(task: task, type: .assignee)
            }
        } else {
            let task = self.taskFetchedResultsController.object(at: realIndex)
            cell.load(task: task, type: .assigner)
        }
        return cell
    }
}

extension UpdatesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let segue: String = indexPath.section == 0 ? "giveUpdate" : "viewUpdate"
        let sender: Any = indexPath.section == 0 ? self.updateRequestFetchedResultsController.object(at: indexPath) : self.taskFetchedResultsController.object(at: IndexPath(row: indexPath.row, section: indexPath.section - 1))
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

//extension MyTasksViewController: NSFetchedResultsControllerDelegate {
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        
//        // If the controller is the invitation controller, then just use the section Index like normal
//    
//        switch type {
//        case .insert:
//            self.tableView.insertSections([sectionIndex], with: .fade)
//        case .delete:
//            self.tableView.deleteSections([sectionIndex], with: .fade)
//        case .move:
//            break
//        case .update:
//            break
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        switch type {
//        case .insert:
//            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            self.tableView.deleteRows(at: [newIndexPath!], with: .fade)
//        case .update: // lots
//                let task = anObject as! Task
//                cell.load(task: task, type: .assignee)
//        case .move:
//            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.endUpdates()
//    }
//}
