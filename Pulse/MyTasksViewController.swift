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
//        let predicate = NSPredicate(format: "receiver.objectId == %@", User.currentUserId())
        
        fetchRequest.sortDescriptors = [sort]
//        fetchRequest.predicate = predicate
        self.taskInvitationFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        
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
            
            
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        TaskService.getMyTasks(success: {
            CoreDataStack.shared.saveContext()
            
//            print("invitation frc sections nil?: \(self.taskInvitationFetchedResultsController.sections)")
//            print("task frc sections nil?: \(self.taskFetchedResultsController.sections)")
            
            do {
                try self.taskInvitationFetchedResultsController.performFetch()
                try self.taskFetchedResultsController.performFetch()
                
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
        var sectionCount = 0
        // If we have any invitations at all, increase section count by 1
        if self.taskInvitationFetchedResultsController.fetchedObjects != nil {
            print(self.taskInvitationFetchedResultsController.fetchedObjects!.count)
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
        
        // Section 0
        // If invitation frc has objects, then it owns section 0
        // If invitation frc does not have objects, then
        
        switch indexPath.section {
        case 0:
            
            if self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0 {
                let taskInvitation = self.taskInvitationFetchedResultsController.object(at: indexPath)
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
                cell.textLabel?.text = "THIS IS AN INVITATION CELL ;)"
                return cell
            }

            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            let task = self.taskFetchedResultsController.object(at: indexPath)
            cell.load(task: task, type: .assignee)
            return cell
            
        case 1:
            
            if self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
                let realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
                let task = self.taskFetchedResultsController.object(at: realIndexPath)
                cell.load(task: task, type: .assignee)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            let realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            let task = self.taskFetchedResultsController.object(at: realIndexPath)
            cell.load(task: task, type: .assignee)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            let realIndexPath = IndexPath(row: indexPath.row, section: indexPath.section - 1)
            let task = self.taskFetchedResultsController.object(at: realIndexPath)
            cell.load(task: task, type: .assignee)
            return cell
        default: return UITableViewCell() // This should never hit
        }
    }
}

extension MyTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let task = self.taskFetchedResultsController.object(at: indexPath)
        taskVC.performSegue(withIdentifier: "viewTask", sender: task)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        switch section {
        case 0:
            if (self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                header.load(status: .pending, type: .assignee)
            } else {
                let sectionInfo = self.taskFetchedResultsController.sections![section]
                print(sectionInfo.name)
                sectionInfo.name == "in_progress" ? header.load(status: .inProgress, type: .assignee) : header.load(status: .completed, type: .assignee)
            }
        case 1:
            if (self.taskInvitationFetchedResultsController.fetchedObjects != nil && self.taskInvitationFetchedResultsController.fetchedObjects?.count != 0) {
                let sectionInfo = self.taskFetchedResultsController.sections![section - 1]
                sectionInfo.name == "in_progress" ? header.load(status: .inProgress, type: .assignee) : header.load(status: .completed, type: .assignee)
            } else {
                let sectionInfo = self.taskFetchedResultsController.sections![section]
                print(sectionInfo.name)
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

//extension MyTasksViewController: NSFetchedResultsControllerDelegate {
//    
//    /*
//     Assume self has a property 'tableView' -- as is the case for an instance of a UITableViewController
//     subclass -- and a method configureCell:atIndexPath: which updates the contents of a given cell
//     with information from a managed object at the given index path in the fetched results controller.
//     */
//    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.beginUpdates()
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//        switch(type) {
//        case .insert:
//            self.tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
//            break
//            
//        case .delete:
//            self.tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
//            break
//        default:
//            break
//        }
//    }
//    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        let tableView: UITableView = self.tableView
//        guard let indexPath: IndexPath = indexPath else { return }
//        switch(type) {
//            
//        case .insert:
//            tableView.insertRows(at: [indexPath], with: .fade)
//            break
//            
//        case .delete:
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            break
//            
//        case .update:
//            guard let cell: UITableViewCell = self.tableView.cellForRow(at: indexPath) else { break }
//            self.configure(cell: cell, at: indexPath)
//            break
//            
//        case .move:
//            self.tableView.deleteRows(at: [indexPath], with: .fade)
//            self.tableView.insertRows(at: [indexPath], with: .fade)
//            break
//        }
//    }
//    
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        self.tableView.endUpdates()
//    }
//}
