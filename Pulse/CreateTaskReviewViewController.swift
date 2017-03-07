//
//  CreateTaskReviewViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskReviewViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assignedLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    
    var taskDictionary: [CreateTaskKeys : [Any]]?
    var tableViewTopInset: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
        self.setupTableView()
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
        if let date = self.taskDictionary![.dueDate]?.first as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            self.dueDateLabel.text = formatter.string(from: date)
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // TODO: Create real task
        TaskService.createTask(title: "Created from iOS app", items: ["test item #1", "test item #2"], assignees: [User.currentUserId()], dueDate: nil, updateDays: [.monday], success: { (task) in
            print("task success")
        }) { (error, statusCode) in
            // TODO: Handle failure
        }
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
                cell.descriptionLabel.text = self.description()
            }
            cell.contentView.backgroundColor = self.tableView.backgroundColor
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CreateTaskReviewItemCell
        if self.taskDictionary != nil {
            cell.itemLabel.text = self.items()[indexPath.row - 1]
        }
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        return cell
    }
    
}
