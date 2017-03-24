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
import UIAdditions

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
    @IBOutlet weak var completedControl: DotControl!
    @IBOutlet weak var titleLabel: UILabel!
    
    var taskInvite: TaskInvitation? {
        didSet {
            guard let task: Task = self.taskInvite?.task else { return }
            self.task = task
        }
    }
    
    var task: Task? {
        didSet {
            // self.updateUI()
            if self.task != nil {
                guard let items: Set<Item> = task?.items as? Set<Item> else { return }
                self.datasource = Array(items)
            }
        }
    }
    
    var datasource: [Item] = [Item]() {
        didSet {
            if self.tableView != nil {
                self.tableView.reloadData()
            }
        }
    }
    private var topGradient: CAGradientLayer = CAGradientLayer()
    var status: TaskStatus?

    var tableViewTopInset: CGFloat = 22
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var task: Task?
        if let vcTask = self.task {
            task = vcTask
        }
        if let vcTask = self.taskInvite?.task {
            task = vcTask
        }
        guard let finalTask = task else { return }
//        self.setupCoreData(task: finalTask)
//        self.fetchData(task: finalTask)
        self.updateUI()
        
        self.tableView.reloadData()
    }
    
    private func setupCoreData(task: Task) {
        let fetchRequest: NSFetchRequest<Item> = Item.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        
       
        let predicate = NSPredicate(format: "task.objectId == %@", task.objectId)
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
//        self.fetchedResultsController.delegate = self
    }
    
    private func fetchData(task: Task) {
        self.checkCache()
        TaskService.getTask(taskId: task.objectId, success: { (task) in
            // If this is not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.fetchedResultsController.delegate = nil
            CoreDataStack.shared.saveContext()
            self.checkCache()
        }) { (error, statusCode) in
            print("Error getting tasks: \(statusCode) \(error.localizedDescription)")
        }
    }
    
    private func checkCache() {
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
//            self.fetchedResultsController.delegate = self
        } catch {
            print("Fetched results controller error: \(error)")
        }
        self.tableView.reloadData()
    }
    
    private func setupAppearance() {
        self.completedControl.emptyColor = UIColor.black.withAlphaComponent(0.2)
        self.completedControl.completedColor = UIColor.white
        let frame: CGRect = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        self.topGradient.frame = frame
        self.topGradient.colors = [appGreen.withAlphaComponent(1.0).cgColor, appGreen.withAlphaComponent(0.0).cgColor]
        self.topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(self.topGradient)
        
//        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
//        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
        
        self.view.backgroundColor = appGreen
        self.avatarImageView.superview!.backgroundColor = self.view.backgroundColor
        
        self.bottomMenu.backgroundColor = UIColor("F1F1F1")
    }

    private func setupTableView() {
        self.tableView.backgroundColor = UIColor.white
        let cell: UINib = UINib(nibName: "TaskItemViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "itemViewCell")
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func updateUI() {
        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
        if let assigner: User = task.assigner {
            self.assignedByLabel.text = "Assigned by: " + assigner.name
            guard let url: URL = URL(string: assigner.avatarURL!) else { return }
            Nuke.loadImage(with: url, into: self.avatarImageView)
        }
        var duePercentString: String = ""
        if let dueDate: Date = task.dueDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            duePercentString = "Due: " + formatter.string(from: dueDate) + " | "
            if dueDate.timeIntervalSince(Date()) <= 86400 {
                self.dueDateLabel.textColor = appRed
            }
            self.dueDateLabel.text = task.status == TaskStatus.completed.rawValue ? "COMPLETED" : duePercentString + "\(Int(task.completionPercentage))% COMPLETED"
        }
        if self.taskInvite != nil {
            self.completedControl.alpha = 0.0
            self.view.backgroundColor = appRed
            self.avatarImageView.superview!.backgroundColor = self.view.backgroundColor
            self.topGradient.colors = [appRed.withAlphaComponent(1.0).cgColor, appRed.withAlphaComponent(0.0).cgColor]
        }
        self.completedControl.percent = CGFloat(task.completionPercentage / 100)
        
        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        self.status = status
        
        switch(status) {
        case .pending:
            self.titleLabel.text = "PENDING TASK"
//            self.dueDateLabel.textColor = appRed
            self.updateButton.setTitle("DECLINE TASK", for: .normal)
            self.updateButton.setTitleColor(UIColor.black, for: .normal)
            self.updateButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let updateBackground: UIImage = ImageWith(color: appRed) else { return }
            self.updateButton.setBackgroundImage(updateBackground, for: .highlighted)
            self.doneButton.setTitle("ACCEPT TASK", for: .normal)
            self.doneButton.setTitleColor(UIColor.black, for: .normal)
            self.doneButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let doneBackground: UIImage = ImageWith(color: appGreen) else { return }
            self.doneButton.setBackgroundImage(doneBackground, for: .highlighted)
            break
        case .inProgress:
            self.titleLabel.text = "IN PROGRESS"
//            self.dueDateLabel.textColor = appYellow
            self.updateButton.setTitle("GIVE UPDATE", for: .normal)
            self.updateButton.setTitleColor(UIColor.black, for: .normal)
            self.updateButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let updateBackground: UIImage = ImageWith(color: appBlue) else { return }
            self.updateButton.setBackgroundImage(updateBackground, for: .highlighted)
            self.doneButton.setTitle("TASK IS DONE", for: .normal)
            self.doneButton.setTitleColor(UIColor.black, for: .normal)
            self.doneButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let doneBackground: UIImage = ImageWith(color: appGreen) else { return }
            self.doneButton.setBackgroundImage(doneBackground, for: .highlighted)
            break
        case .completed:
            self.tableView.backgroundColor = appGreen
            self.titleLabel.text = "COMPLETED TASK"
//            self.dueDateLabel.textColor = appGreen
            self.bottomMenu.alpha = 0
//            self.dueDateLabel.text = "COMPLETED"
            self.tableView.reloadData()
            break
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        if sender == self.updateButton {
            sender.layer.borderColor = status == .pending ? appRed.cgColor : appBlue.cgColor
        } else if sender == self.doneButton {
            sender.layer.borderColor = appGreen.cgColor
        }
    }
    
    @IBAction func buttonRelease(_ sender: UIButton) {
        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        sender.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        guard let task: Task = self.task else { print("No task"); return }
        if let status = self.status {
            switch(status) {
            case .pending:
                // Decline Task
                guard let taskInvitation: TaskInvitation = self.taskInvite else { print("No task invitation"); return }
                TaskInvitationService.respondToTaskInvitation(taskInvitationId: taskInvitation.objectId, status: .denied, success: { (invitation) in
                    // Success, do something
                    self.backButtonPressed(UIButton())
                    CoreDataStack.shared.saveContext()
                }, failure: { (error, statusCode) in
                    // Error
                    
                })
                break
            case .inProgress:
                // Send Update for Task
                guard let task: Task = self.task else { return }
                self.performSegue(withIdentifier: "giveUpdate", sender: task)
                break
            case .completed:
                break
            }
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let task: Task = self.task else { print("No task"); return }
        
        if let status = self.status {
            switch(status) {
            case .pending:
                // Accept Task
                guard let taskInvitation: TaskInvitation = self.taskInvite else { print("No task invitation"); return }
                TaskInvitationService.respondToTaskInvitation(taskInvitationId: taskInvitation.objectId, status: .accepted, success: { (invitation) in
                    
                    CoreDataStack.shared.saveContext()
                    
                    // Success, do something
                    // Unwind to previous page
                    self.backButtonPressed(UIButton())
                }, failure: { (error, statusCode) in
                    // Error
                    
                })
                break
            case .inProgress:
                // Mark Task as Completed
                TaskService.finishTask(taskId: task.objectId, success: { (task) in
                    
                    CoreDataStack.shared.saveContext()
                    
                    // Update task and UI to reflect the change.
//                    self.task = task
//                    self.updateUI()
                }, failure: { (error, statusCode) in
                    // Error
                    
                })
                break
            case .completed:
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "giveUpdate" {
            guard let destination: TaskUpdateViewController = segue.destination as? TaskUpdateViewController else { return }
            guard let task: Task = sender as? Task else { return }
            destination.task = task
        }
    }
}

extension ViewTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.fetchedResultsController.sections?.count ?? 1
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let sectionInfo: NSFetchedResultsSectionInfo = self.fetchedResultsController.sections?[section] else { return 1 }
//        return sectionInfo.numberOfObjects + 1
        
        return self.datasource.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemViewCell", for: indexPath) as! TaskItemViewCell
        
        if indexPath.row == 0 {
            cell.contentView.backgroundColor = self.view.backgroundColor
            cell.label.text = self.task?.title
            cell.button.alpha = 0
        } else {
            cell.contentView.backgroundColor = UIColor.white
            cell.label.textColor = UIColor.black
            let realIndexPath: IndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
//            let item = self.fetchedResultsController.object(at: realIndexPath)
            let item: Item = self.datasource[realIndexPath.row]
            cell.load(item: item)
            
            if let status = self.status {
                switch(status) {
                case .pending:
                    cell.button.alpha = 0.0
                    cell.dot.alpha = 1.0
                    break
                case .inProgress:
                    break
                case .completed:
                    cell.state = .selected
                    cell.button.isEnabled = false
                    cell.contentView.backgroundColor = appGreen
                    cell.label.textColor = UIColor.white
                    break
                }
            }
        }
        return cell
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y > 0.0 {
//            scrollView.backgroundColor = UIColor.white
//        } else if scrollView.contentOffset.y < 0.0 {
//            scrollView.backgroundColor = self.view.backgroundColor
//        }
//    }
}

extension ViewTaskViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        //
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard var indexPath: IndexPath = indexPath else { return }
        indexPath.row += 1
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [indexPath], with: .fade)
            
        case .delete:
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        case .update:
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell {
                cell.load(anObject, type: .myTask)
            }
            
        case .move:
            guard var newIndexPath: IndexPath = newIndexPath else { return }
            newIndexPath.row += 1
            self.tableView.moveRow(at: indexPath, to: newIndexPath)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
}
