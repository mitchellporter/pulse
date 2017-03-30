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
    
    let headerStatus: [TaskStatus] = [.pending, .inProgress, .completed]
    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupCoreData()
//        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchData()
    }
    
    private func setupCoreData() {
        
        // Setup Pending FRC
        let fetchRequest: NSFetchRequest<Task> = Task.createFetchRequest()
        let assignerPredicate: NSPredicate = NSPredicate(format: "assigner.objectId == %@", User.currentUserId())

        let sort = NSSortDescriptor(key: "status", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = assignerPredicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "status", cacheName: nil)
    }
    
    private func fetchData() {
        self.checkCache()
        TaskService.getTasksCreated(success: {
            // If this is not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.fetchedResultsController.delegate = nil
            CoreDataStack.shared.saveContext()
            self.checkCache()
        }) { (error, statusCode) in
            print("Error getting tasks: \(statusCode ?? 000) \(error.localizedDescription)")
        }
    }
    
    private func checkCache() {
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
            self.fetchedResultsController.delegate = self
        } catch {
            print("Fetched results controller error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "taskCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: 13, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = UIColor("ECEFF1")
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 13)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [UIColor("ECEFF1").cgColor, UIColor("ECEFF1").withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
    }
}

extension CreatedTasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        let item: Task = self.fetchedResultsController.object(at: indexPath)
        cell.load(item, type: .createdTask)
        return cell
    }
}

extension CreatedTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let taskVC: TaskViewController = self.parent as? TaskViewController else { return }
        let sender: Any = self.fetchedResultsController.object(at: indexPath)
        taskVC.performSegue(withIdentifier: "editTask", sender: sender)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let fetchedObjects = self.fetchedResultsController.sections?[section].objects else { return nil }
        if fetchedObjects.count > 0 {
            guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
            header.contentView.backgroundColor = self.tableView.backgroundColor
            let position: TaskSectionHeader.CellPosition = section == 0 ? .top : .normal
            let sectionInfo = self.fetchedResultsController.sections![section]
            
            header.load(status: TaskStatus(rawValue: sectionInfo.name)!, type: position)
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let fetchedObjects = self.fetchedResultsController.sections?[section].objects else {
            return 0
        }
        if fetchedObjects.count != 0 {
            if section == 0 {
                return 48
            }
            return 35
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
        case .update:
            guard let indexPath: IndexPath = indexPath else { return }
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell {
                cell.load(anObject, type: .createdTask)
            }
        case .move:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}




