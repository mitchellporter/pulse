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
    
    var taskInvitationFetchedResultsController: NSFetchedResultsController<TaskInvitation>!
    var taskFetchedResultsController: NSFetchedResultsController<Task>!
//    var sectionCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupTaskInvitationCoreData()
        self.setupTaskCoreData()
        self.fetchData()
    }
    
    // FRC Notes:
    // An FRC's sections property is nil until you call performFetch for the first time. Then it is initialized.
    // If an FRC doesn not provide a sectionNameKeyPath, the sections array contains 1 default section info item
    // If an FRC does provide a sectionNameKeyPath, the sections array remains empty until you actually have data to sort and separate into sections
    
    private func setupTaskInvitationCoreData() {
        // Task invitations
        let fetchRequest: NSFetchRequest<TaskInvitation> = TaskInvitation.createFetchRequest()
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
        self.taskInvitationFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "status", cacheName: nil)
//        self.taskInvitationFetchedResultsController.delegate = self
//        print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
    }
    
    private func setupTaskCoreData() {
        // Tasks
        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "status", ascending: false)
        let predicate = NSPredicate(format: "ANY assignees.objectId == %@", User.currentUserId())
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.taskFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "status", cacheName: nil)
//        self.taskFetchedResultsController.delegate = self
        
//        print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
        
    }
    
    private func fetchData() {
        
//        print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
//        print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
        
        // Check cache
        do {
            try self.taskInvitationFetchedResultsController.performFetch()
            try self.taskFetchedResultsController.performFetch()
            
//            print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections![0].numberOfObjects)")
//            print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
            
            self.taskInvitationFetchedResultsController.delegate = self
            self.taskFetchedResultsController.delegate = self
            
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        TaskService.getMyTasks(success: {
            
            // If these are not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.taskInvitationFetchedResultsController.delegate = nil
            self.taskFetchedResultsController.delegate = nil

            CoreDataStack.shared.saveContext()
            
//            print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
//            print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
            do {
                try self.taskInvitationFetchedResultsController.performFetch()
                try self.taskFetchedResultsController.performFetch()
                
                self.taskInvitationFetchedResultsController.delegate = self
                self.taskFetchedResultsController.delegate = self
                
//                print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
//                print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
                
                
//                print("task sections: \(self.taskFetchedResultsController.sections?.count ?? 1)")
//                print("first section info: \(self.taskFetchedResultsController.sections![0].name)")
//                print("second section info: \(self.taskFetchedResultsController.sections![1].name)")
//                print("first section objects count: \(self.taskFetchedResultsController.sections![0].numberOfObjects)")
//                print("second section objects count: \(self.taskFetchedResultsController.sections![1].numberOfObjects)")

                print(self.taskInvitationFetchedResultsController.fetchedObjects?.count)
                print(self.taskFetchedResultsController.fetchedObjects?.count)
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
        var sectionCount = 0
        // If we have any invitations at all, increase section count by 1
        if self.taskInvitationFetchedResultsController.fetchedObjects != nil {
            if (self.taskInvitationFetchedResultsController.fetchedObjects!.count != 0) {
                sectionCount += 1
            }
        }
        // If task frc has sections, then increase count by frc's section count
        if let sections = self.taskFetchedResultsController.sections {
            sectionCount += sections.count
        }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Section 0
        // If invitation frc has objects, then it owns section 0
        // If invitation frc does not have objects, then task frc owns section 0
        
        // Section 1
        // If invitation frc has objects, then section 1 gets task frc's section index 0 info
        // If invitation frc does not have objects, then section 1 gets task frc's section index 1 info
        
        // Section 2
        // Section 2 can just always return task frc's section index 1 info because if a section "2" (3) exists,
        // that's the only possible explanation
        
        switch section {
        case 0:
            if self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0 {
                return self.taskInvitationFetchedResultsController.fetchedObjects?.count ?? 0
            }
            let sectionInfo = self.taskFetchedResultsController.sections![0]
            return sectionInfo.numberOfObjects
        case 1:
            if self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0 {
                guard let sections = self.taskFetchedResultsController.sections else {
                    print("fetched count: \(self.taskFetchedResultsController.fetchedObjects?.count ?? 0)")
                    return self.taskFetchedResultsController.fetchedObjects?.count ?? 0
                }
                
                if (sections.count != 0) {
                    let sectionInfo = sections[0]
                    return sectionInfo.numberOfObjects
                }
            }
            let sectionInfo = self.taskFetchedResultsController.sections![1]
            return sectionInfo.numberOfObjects
        case 2:
            let sectionInfo = self.taskFetchedResultsController.sections![1]
            return sectionInfo.numberOfObjects
        default: return 0 // This should never hit
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        var realIndexPath: IndexPath = indexPath
        
        // Section 0
        // If invitation frc has objects, then it owns section 0
        // If invitation frc does not have objects, then
        switch indexPath.section {
        case 0:
            if self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0 {
                let taskInvitation: TaskInvitation = self.taskInvitationFetchedResultsController.object(at: indexPath)
                cell.load(invitation: taskInvitation, type: .assigner)
                return cell
            }
        case 1:
            if self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0 {
                realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
            } else {
                realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            }
        case 2:
            realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
        default: return UITableViewCell() // This should never hit
        }
        
        let task = self.taskFetchedResultsController.object(at: realIndexPath)
        cell.load(task: task, type: .assigner)
        return cell
    }
}

extension MyTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        var sender: Any?
        if indexPath.section == 0 {
            if (self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                sender = self.taskInvitationFetchedResultsController.object(at: indexPath)
            } else {
                sender = self.taskFetchedResultsController.object(at: indexPath)
            }
        } else {
            if (self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                let realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                sender = self.taskFetchedResultsController.object(at: realIndexPath)
            } else {
                sender = self.taskFetchedResultsController.object(at: indexPath)
            }
        }
        taskVC.performSegue(withIdentifier: "viewTask", sender: sender)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        switch section {
        case 0:
            if (self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                header.load(status: .pending, type: .assignee)
            } else {
                let sectionInfo = self.taskFetchedResultsController.sections![section]
                sectionInfo.name == "in_progress" ? header.load(status: .inProgress, type: .assignee) : header.load(status: .completed, type: .assignee)
            }
        case 1:
            if (self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                let sectionInfo = self.taskFetchedResultsController.sections![section - 1]
                sectionInfo.name == "in_progress" ? header.load(status: .inProgress, type: .assignee) : header.load(status: .completed, type: .assignee)
            } else {
                let sectionInfo = self.taskFetchedResultsController.sections![section]
                sectionInfo.name == "in_progress" ? header.load(status: .inProgress, type: .assignee) : header.load(status: .completed, type: .assignee)
            }
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
        
        // If the controller is the invitation controller, then just use the section Index like normal
        switch type {
        case .insert:
            if controller == self.taskInvitationFetchedResultsController {
                self.tableView.insertSections([sectionIndex], with: .fade)
            } else if controller == self.taskFetchedResultsController {
               // self.tableView.insertSections([sectionIndex], with: .fade)
                
                var realSectionIndex: Int
                if (self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                    realSectionIndex = sectionIndex + 1
                } else {
                    realSectionIndex = sectionIndex
                }
                
                self.tableView.insertSections([realSectionIndex], with: .fade)
            }
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
        case .insert: // a few
            
            if controller == self.taskInvitationFetchedResultsController {
                self.tableView.insertRows(at: [newIndexPath!], with: .fade)
            } else if controller == self.taskFetchedResultsController {
                
                var realIndexPath: IndexPath
                if (self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: newIndexPath!.row, section: newIndexPath!.section)
                }
                
                self.tableView.insertRows(at: [realIndexPath], with: .fade)
            }
            
        case .delete:
            
            if controller == self.taskInvitationFetchedResultsController {
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
            } else if controller == self.taskFetchedResultsController {
                var realIndexPath: IndexPath
                if (self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section)
                }
                self.tableView.deleteRows(at: [realIndexPath], with: .fade)
            }
            
        case .update: // lots
            if controller == self.taskInvitationFetchedResultsController {
                if let cell = self.tableView.cellForRow(at: indexPath!) as? TaskCell {
                    
                    let task = self.taskFetchedResultsController.fetchedObjects!.first!
                    cell.load(task: task, type: .assignee)
                }
            } else if controller == self.taskFetchedResultsController {
                var realIndexPath: IndexPath
                if (self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section + 1)
                } else {
                    realIndexPath = IndexPath(row: indexPath!.row, section: indexPath!.section)
                }
                if let cell = self.tableView.cellForRow(at: realIndexPath) as? TaskCell {
                    let task = anObject as! Task
                    cell.load(task: task, type: .assignee)
                }
            }
            break
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
