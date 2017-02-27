//
//  TaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    enum ViewMode: Int {
        case myTasks
        case createdTasks
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: Button!
    
    @IBOutlet weak var myTasksButton: Button!
    @IBOutlet weak var createdTasksButton: Button!
    
    var tableViewDatasource: TaskViewControllerDatasource = TaskViewControllerDatasource()
    private var modeSelected: ViewMode = .myTasks {
        didSet {
            if oldValue != self.modeSelected {
                self.updateView(mode: self.modeSelected)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCoreData()
        self.setupTableView()
        
        do {
            try self.tableViewDatasource.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        TaskService.getTasksAssignedToUser(assigneeId: User.currentUserId(), offset: 0, success: { (tasks) in
            
            CoreDataStack.shared.saveContext()
            
            do {
                try self.tableViewDatasource.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print("fetched results controller error: \(error)")
            }
        }) { (error, statusCode) in
            // TODO: Handle failure
        }
    }
    
    private func updateView(mode: ViewMode) {
        switch mode {
        case .myTasks:
            self.myTasksButton.alpha = 1
            self.createdTasksButton.alpha = 0.3
            
            self.tableViewDatasource.dataType = mode.rawValue
            // 
            self.tableView.reloadData()
        case .createdTasks:
            self.createdTasksButton.alpha = 1
            self.myTasksButton.alpha = 0.3
            
            self.tableViewDatasource.dataType = mode.rawValue
//            self.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        self.tableView.register(TaskSectionHeader.self, forHeaderFooterViewReuseIdentifier: "taskHeader")
        let cell: UINib = UINib(nibName: "TaskCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "taskCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 0, right: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self.tableViewDatasource
    }
    
    private func setupCoreData() {
        let request: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "status", cacheName: nil)
        self.tableViewDatasource.fetchedResultsController = fetchedResultsController
        
        // TODO
//        self.updatePredicate(for: "")
    }
    
    private func updatePredicate(for type: String) {
        // TODO
//        let predicate = NSPredicate(format: "ANY projects.objectId == %@")
//        self.tableViewDatasource.fetchedResultsController.fetchRequest.predicate = predicate
    }

    @IBAction func myTasksPressed(_ sender: UIButton) {
        self.modeSelected = .myTasks
    }
    
    @IBAction func createdTasksPressed(_ sender: UIButton) {
        self.modeSelected = .createdTasks
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
    
    func configure(cell: TaskCell, at indexPath: IndexPath) {
        let task = self.tableViewDatasource.fetchedResultsController.object(at: indexPath)
        cell.load(task: task)
    }
}

extension TaskViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "viewTask", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("section: \(section)")
        guard let header: TaskSectionHeader = tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") as? TaskSectionHeader else { return tableView.dequeueReusableHeaderFooterView(withIdentifier: "taskHeader") }
//        header.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: tableView.frame.width, height: 30))
        header.load(status: .inProgress)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
}
