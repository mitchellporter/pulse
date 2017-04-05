//
//  EditTaskViewController.swift
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
class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var backButton: Button!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: Button!
    @IBOutlet weak var cancelButton: Button!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assignedByLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var requestButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var completedControl: DotControl!
    @IBOutlet weak var taskDescriptionLabel: UILabel!
    
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
                guard let items = task?.items as? Set<Item> else { return }
                self.datasource = [Item](items)
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
//    private var topGradient: CAGradientLayer = CAGradientLayer()
    var status: TaskStatus?
    
    var tableViewTopInset: CGFloat = 22
    
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    fileprivate var editingTask: Bool = false {
        didSet {
            self.editTask()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.task != nil {
//            self.setupCoreData()
//            self.fetchData()
            self.updateUI()
        }
        
        self.tableView.reloadData()
    }

    private func setupCoreData() {
        guard let task: Task = self.task else { return }
        let fetchRequest: NSFetchRequest<Item> = Item.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let predicate = NSPredicate(format: "task.objectId == %@", task.objectId)
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    private func fetchData() {
        
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        guard let task: Task = self.task else { return }
        TaskService.getTask(taskId: task.objectId, success: { (task) in
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
        self.completedControl.emptyColor = UIColor.black.withAlphaComponent(0.1)
        self.completedControl.completedColor = UIColor.white
//        let frame: CGRect = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
//        self.topGradient.frame = frame
//        self.topGradient.colors = [appBlue.withAlphaComponent(1.0).cgColor, appBlue.withAlphaComponent(0.0).cgColor]
//        self.topGradient.locations = [0.0, 1.0]
//        
//        self.view.layer.addSublayer(self.topGradient)
        
//        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
//        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
        
        self.view.backgroundColor = appBlue
        self.avatarImageView.superview!.backgroundColor = self.view.backgroundColor
        self.bottomMenu.backgroundColor = UIColor("F1F1F1")
    }
    
    private func updateUI() {
        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
        if let assineesSet: Set<User> = task.assignees as? Set<User> {
            let assignees: [User] = Array(assineesSet)
            var assigneeText: String = "Assigned to: "
            for (i, assignee) in assignees.enumerated() {
                assigneeText = i > 0 ? assigneeText + " ," + assignee.name : assigneeText + " " + assignee.name
                if i == 0 {
                    guard let avatarURL: String = assignee.avatarURL else { return }
                    guard let url: URL = URL(string: avatarURL) else { return }
                    Nuke.loadImage(with: url, into: self.avatarImageView)
                }
            }
            self.assignedByLabel.text = "Assigned to: "
        }
        
        var duePercentString: String = ""
        if let dueDate: Date = task.dueDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            duePercentString = "Due: " + formatter.string(from: dueDate) + " | "
            if dueDate.timeIntervalSince(Date()) <= 86400 {
//                self.dueDateLabel.textColor = appRed
            }
            self.dueDateLabel.text = task.status == TaskStatus.completed.rawValue ? "COMPLETED" : duePercentString + "\(Int(task.completionPercentage))% COMPLETED"
        }
        
        self.taskDescriptionLabel.text = task.title
        
        if self.taskInvite != nil {
            self.completedControl.alpha = 0.0
//            self.view.backgroundColor = appRed
//            self.avatarImageView.superview!.backgroundColor = self.view.backgroundColor
        }
        self.completedControl.percent = CGFloat(task.completionPercentage / 100)
        
        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        self.status = status
        
        self.titleLabel.text = "TASK CREATED"
        
        switch(status) {
        case .pending:
//            self.dueDateLabel.textColor = appRed
            self.requestButton.setTitle("ASK FOR UPDATE", for: .normal)
            self.requestButton.setTitleColor(UIColor.black, for: .normal)
            self.requestButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let requestBackground: UIImage = ImageWith(color: appBlue) else { return }
            self.requestButton.setBackgroundImage(requestBackground, for: .highlighted)
            self.editButton.setTitle("EDIT TASK", for: .normal)
            self.editButton.setTitleColor(UIColor.black, for: .normal)
            self.editButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let editBackground: UIImage = ImageWith(color: appGreen) else { return }
            self.editButton.setBackgroundImage(editBackground, for: .highlighted)
            break
        case .inProgress:
//            self.dueDateLabel.textColor = appYellow
            self.requestButton.setTitle("ASK FOR UPDATE", for: .normal)
            self.requestButton.setTitleColor(UIColor.black, for: .normal)
            self.requestButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let requestBackground: UIImage = ImageWith(color: appBlue) else { return }
            self.requestButton.setBackgroundImage(requestBackground, for: .highlighted)
            self.editButton.setTitle("EDIT TASK", for: .normal)
            self.editButton.setTitleColor(UIColor.black, for: .normal)
            self.editButton.setTitleColor(UIColor.white, for: .highlighted)
            guard let editBackground: UIImage = ImageWith(color: appGreen) else { return }
            self.editButton.setBackgroundImage(editBackground, for: .highlighted)
            break
        case .completed:
//            self.dueDateLabel.textColor = appGreen
            self.bottomMenu.alpha = 0
            break
        }
    }
    
    private func setupTableView() {
        self.tableView.backgroundColor = UIColor.white
        let editCell: UINib = UINib(nibName: "TaskItemEditCell", bundle: nil)
        self.tableView.register(editCell, forCellReuseIdentifier: "taskItemEditCell")
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        for constraint in self.bottomMenu.constraints {
            if constraint.firstAttribute == .height {
                self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: constraint.constant, right: 0)
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
//        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
//        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        if sender == self.requestButton {
            sender.layer.borderColor = appBlue.cgColor
        } else if sender == self.editButton {
            sender.layer.borderColor = appGreen.cgColor
        }
    }
    
    @IBAction func buttonRelease(_ sender: UIButton) {
//        guard let task: Task = self.task else { print("Error: no task on ViewTaskViewController"); return }
//        guard let status: TaskStatus = TaskStatus(rawValue: task.status) else { print("Error: no status on task"); return }
        sender.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        
        if let status = self.status {
            switch(status) {
            case .pending:
                AlertManager.presentPassiveAlert(of: .requestDisabled, with: "")
                break
            case .inProgress:
                // Request Update for Task
                guard let task: Task = self.task else { print("No task"); return }
                UpdateService.requestTaskUpdate(taskId: task.objectId, success: { (updateRequest) in
                    CoreDataStack.shared.saveContext()
                    
                    AlertManager.presentPassiveAlert(of: .requestSent, with: "")
                }) { (error, statusCode) in
                    print("Error: \(statusCode ?? 000) \(error.localizedDescription)")
                }
                break
            case .completed:
                break
            }
        }
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
//        guard let task: Task = self.task else { print("No task"); return }
        if let status = self.status {
            switch(status) {
            case .pending:
                break
            case .inProgress:
                // Make changes to task
                break
            case .completed:
                break
            }
        }
        
        let alert: UIAlertController = UIAlertController(title: "EDIT TASK", message: "Choose an action", preferredStyle: .alert)
        
        let inviteAction: UIAlertAction = UIAlertAction(title: "Add Assignees", style: .default) { _ in
            self.performSegue(withIdentifier: "invite", sender: self.task)
        }
        
        let deleteAction: UIAlertAction = UIAlertAction(title: "DELETE TASK", style: .destructive) { _ in
            // TODO: Call delete service method here.
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(inviteAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func reminderButtonPressed(_ sender: UIButton) {
        AlertManager.presentPassiveAlert(of: .reminderComingSoon, with: "")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func editTask() {
        UIView.animate(withDuration: 0.1, animations: {
            self.backButton.alpha = self.editingTask ? 0 : 1
            self.cancelButton.alpha = self.editingTask ? 1 : 0
            self.titleLabel.alpha = self.editingTask ? 1 : 0
            self.updateButton.alpha = self.editingTask ? 1 : 0
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.editingTask = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "invite" {
            guard let task: Task = sender as? Task else { return }
            guard let toVC: CreateTaskAssignViewController = segue.destination as? CreateTaskAssignViewController else { return }
            
            toVC.task = task
        }
    }
}

extension EditTaskViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.fetchedResultsController.sections?.count ?? 1
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let sectionInfo = self.fetchedResultsController.sections![section]
//        return sectionInfo.numberOfObjects + 1
        
//        return self.datasource.count + 1
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskItemEditCell", for: indexPath) as! TaskItemEditCell
        
//        if indexPath.row == 0 {
//            cell.contentView.backgroundColor = self.view.backgroundColor
//            cell.textView.text = self.task?.title
//            cell.button.alpha = 0
//        } else {
            cell.contentView.backgroundColor = self.tableView.backgroundColor
            cell.delegate = self
            cell.textView.textColor = UIColor.black
        let realIndexPath: IndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
//            let realIndexPath: IndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
//            let item = self.fetchedResultsController.object(at: realIndexPath)
            let item: Item = self.datasource[realIndexPath.row]
            cell.load(item: item)
            
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
                }
            }
//        }
        return cell
    }
}

extension EditTaskViewController: TaskItemCellDelegate {
    
    func taskUpdated(item: String) {
        self.editingTask = true
    }
}
