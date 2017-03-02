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
    
//    var fetchedResultsController: NSFetchedResultsController<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "taskCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = mainBackgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

//    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
//        _ = self.fetchedResultsController.object(at: indexPath)
//        // Setup cell
//    }
    
//    private func setupCoreData() {
//        let request: NSFetchRequest<Task> = Task.createFetchRequest()
//        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
//        request.sortDescriptors = [sort]
//        let fetchedResultsController: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType), sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultsController.delegate = self
//        self.fetchedResultsController = fetchedResultsController
//        self.tableViewDatasource.fetchedResultsController = fetchedResultsController
//        // TODO
//        self.updatePredicate(for: "")
//    }
//    
//    private func updatePredicate(for type: String) {
//        // TODO
//        let predicate = NSPredicate(format: "ANY projects.objectId == ")
//        self.tableViewDatasource.fetchedResultsController.fetchRequest.predicate = predicate
//    }
    
}

extension MyTasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {
            return tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        }
        
        
        
        return cell
    }
}

extension MyTasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let segueID: String = self.modeSelected == .myTasks ? "viewTask" : "editTask"
//        self.performSegue(withIdentifier: segueID, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
        //        header.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.frame.width, height: 30))
        header.load(status: .inProgress)
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
