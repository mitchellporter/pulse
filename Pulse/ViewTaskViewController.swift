//
//  ViewTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData
import Nuke

// TODO: Setup description cell
class ViewTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var backButton: Button!
    @IBOutlet weak var updateButton: Button!
    @IBOutlet weak var doneButton: Button!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var task: Task? {
        didSet {
            self.updateUI()
        }
    }
    
    var status: TaskStatus?

    var tableViewTopInset: CGFloat = 22
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
        self.setupCoreData()
        self.fetchData()
    }
    
    private func setupCoreData() {
        let fetchRequest: NSFetchRequest<Item> = Item.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let predicate = NSPredicate(format: "task.objectId == %@", self.task!.objectId)
        
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
        
        TaskService.getTask(taskId: self.task!.objectId, success: { (task) in
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
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [mainBackgroundColor.withAlphaComponent(1.0).cgColor, mainBackgroundColor.withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
        
        self.view.backgroundColor = mainBackgroundColor
        self.avatarImageView.superview!.backgroundColor = self.view.backgroundColor
    }

    private func setupTableView() {
        self.tableView.backgroundColor = self.view.backgroundColor
        let cell: UINib = UINib(nibName: "TaskItemViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "itemViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
        self.tableView.dataSource = self
    }
    
    private func updateUI() {
        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
        if let assigner: User = task.assigner {
            print(self.task)
            print(assigner)
            print(assigner.name!)
            self.assignedByLabel.text = "Assigned by: " + assigner.name!
            guard let url: URL = URL(string: assigner.avatarURL!) else { return }
            Nuke.loadImage(with: url, into: self.avatarImageView)
        }
        if let dueDate: Date = task.dueDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            self.dueDateLabel.text = formatter.string(from: dueDate)
        }
        
        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        self.status = status
        
        switch(status) {
        case .pending:
            self.dueDateLabel.textColor = appRed
            self.updateButton.setTitle("DECLINE TASK", for: .normal)
            self.doneButton.setTitle("ACCEPT TASK", for: .normal)
            break
        case .inProgress:
            self.dueDateLabel.textColor = appYellow
            self.updateButton.setTitle("GIVE UPDATE", for: .normal)
            self.doneButton.setTitle("TASK IS DONE", for: .normal)
            break
        case .completed:
            self.dueDateLabel.textColor = appGreen
            break
        default:
            break
        }
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        if let status = self.status {
            switch(status) {
            case .pending:
                // Decline Task
                break
            case .inProgress:
                // Send Update for Task
                break
            case .completed:
                break
            default:
                break
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        if let status = self.status {
            switch(status) {
            case .pending:
                // Accept Task
                break
            case .inProgress:
                // Mark Task as Completed
                break
            case .completed:
                break
            default:
                break
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ViewTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemViewCell", for: indexPath) as! TaskItemViewCell
        let item = self.fetchedResultsController.object(at: indexPath)
        cell.load(item: item)
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        if let status = self.status {
            switch(status) {
            case .pending:
                cell.button.alpha = 0
                break
            case .inProgress:
                break
            case .completed:
                cell.state = .selected
                cell.button.isEnabled = false
                break
            default:
                break
            }
        }
        return cell
    }
}
