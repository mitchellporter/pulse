//
//  CreateTaskReviewViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskReviewViewController: CreateTask {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var taskDictionary: [CreateTaskKeys : [Any]]?
    var tableViewTopInset: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
        self.setupTableView()
        self.displayTask()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            guard let previousViewController: CreateTaskUpdatesViewController = NavigationManager.getPreviousViewController(CreateTaskUpdatesViewController.self, from: self) as? CreateTaskUpdatesViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        }
    }
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: (self.avatarImageView.superview!.frame.origin.y + self.avatarImageView.superview!.frame.height), width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [createTaskBackgroundColor.cgColor, createTaskBackgroundColor.withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
        
        self.view.backgroundColor = createTaskBackgroundColor
    }
    
    private func setupTableView() {
        let descriptionCell: UINib = UINib(nibName: "CreateTaskReviewDescriptionCell", bundle: nil)
        self.tableView.register(descriptionCell, forCellReuseIdentifier: "descriptionCell")
        let itemCell: UINib = UINib(nibName: "CreateTaskReviewItemCell", bundle: nil)
        self.tableView.register(itemCell, forCellReuseIdentifier: "itemCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 45
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
    }
    
    private func displayTask() {
        self.dueDateLabel.text = ""
        guard let dictionary: Dictionary<CreateTaskKeys,[Any]> = self.taskDictionary else { return }
        if let assignees: [User] = dictionary[.assignees] as? [User] {
            var assigneeString: String = "Assigned to:"
            for (index, member) in assignees.enumerated() {
                let name: String = member.name
                assigneeString = index == 0 ? "\(assigneeString) \(name)" : "\(assigneeString), \(name)"
            }
        }
        if let date: Date = dictionary[.dueDate]?.first as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            self.dueDateLabel.text = "Due: " + formatter.string(from: date)
        } else {
            self.dueDateLabel.text = ""
        }
        if let updates: [WeekDay] = dictionary[.updateInterval] as? [WeekDay] {
            if updates.count > 0 {
                var days: String = ""
                var dayStrings: [String] = [String]()
                if updates.contains(.monday) {
                    dayStrings.append("Mon")
                }
                if updates.contains(.wednesday) {
                    dayStrings.append("Wed")
                }
                if updates.contains(.friday) {
                    dayStrings.append("Fri")
                }
                for (index, dayString) in dayStrings.enumerated() {
                    days = index > 0 ? days + ", \(dayString)" : dayString
                }
                if let text: String = self.dueDateLabel.text {
                    self.dueDateLabel.text = dictionary[.dueDate]?.first == nil ? "Notify \(days)" : text + " | Notify \(days)"
                }
            }
        }
    }
    
    fileprivate func description() -> String? {
        guard let dictionary = self.taskDictionary else { print("No dictionary on review controller"); return nil }
        guard let description = dictionary[.description] else { print("No description in dictionary"); return nil }
        return description.first as? String
    }
    
    fileprivate func items() -> [String] {
        var itemsArray: [String] = [String]()
        guard let dictionary = self.taskDictionary else { print("No dictionary on review controller"); return itemsArray }
        guard let items = dictionary[.items] as? [String] else { print("No items in dictionary"); return itemsArray }
        itemsArray = items
        return itemsArray
    }
    
//    private func create(task: [CreateTaskKeys:[Any]]) {
//        guard let description: String = task[.description]?.first as? String else { return }
//        guard let items: [String] = task[.items] as? [String] else { return }
//        guard let assignees: [User] = task[.assignees] as? [User] else { return }
//        var members: [String] = [String]()
//        for member in assignees {
//            members.append(member.objectId)
//        }
//        let dueDate: Date? = task[.dueDate]?.first as? Date
//        let updateInterval: [WeekDay] = task[.updateInterval] == nil ? [WeekDay]() : task[.updateInterval]! as! [WeekDay]
//        TaskService.createTask(title: description, items: items, assignees: members, dueDate: dueDate, updateDays: updateInterval, success: { (task) in
//            // Successfully created task
//            // Do Something
//            
//            self.performSegue(withIdentifier: "assign", sender: nil)
//        }) { (error, statusCode) in
//            // TODO: Handle Error
//            print("There was an error when creating the task. Error: \(statusCode) \(error.localizedDescription)")
//        }
//    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "assign", sender: self.taskDictionary)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskAssignViewController else { return }
        toVC.taskDictionary = dictionary
    }
}

extension CreateTaskReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.taskDictionary != nil {
            return self.items().count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! CreateTaskReviewDescriptionCell
            if self.taskDictionary != nil {
                cell.load(text: self.description())
            }
            cell.delegate = self
            cell.contentView.backgroundColor = self.tableView.backgroundColor
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CreateTaskReviewItemCell
        cell.load(self.items()[indexPath.row - 1])
        cell.delegate = self
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        return cell
    }
}

extension CreateTaskReviewViewController: CreateTaskReviewItemCellDelegate, CreateTaskReviewDescriptionCellDelegate {
    
    func cellNeedsResize(_ cell: UITableViewCell) {
        // resize
    }
    
    func taskItemReview(cell: CreateTaskReviewItemCell, didUpdate text: String) {
        guard let roughIndexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        let indexPath: IndexPath = IndexPath(row: roughIndexPath.row - 1, section: roughIndexPath.section)
        _ = indexPath
        var items = self.items()
        items[indexPath.row] = text
        _ = self.taskDictionary?.updateValue(items, forKey: .items)
    }
    
    func taskDescriptionReview(cell: CreateTaskReviewDescriptionCell, didUpdate text: String) {
        _ = self.taskDictionary?.updateValue([text], forKey: .description)
    }
}
