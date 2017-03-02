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
        topGradient.colors = [UIColor("1AB17CFF").cgColor, UIColor("1AB17C00").cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
    }
    
    private func setupTableView() {
        let descriptionCell: UINib = UINib(nibName: "CreateTaskReviewDescriptionCell", bundle: nil)
        self.tableView.register(descriptionCell, forCellReuseIdentifier: "descriptionCell")
        let itemCell: UINib = UINib(nibName: "CreateTaskReviewItemCell", bundle: nil)
        self.tableView.register(itemCell, forCellReuseIdentifier: "itemCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 45
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
    }
    
    private func displayTask() {
        if let date = self.taskDictionary![.dueDate]?.first as? Date {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            self.dueDateLabel.text = formatter.string(from: date)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // Create task
    }
}

extension CreateTaskReviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.taskDictionary != nil {
            guard let itemCount: Int = self.taskDictionary![.items]?.count else { return 1 }
            return itemCount + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! CreateTaskReviewDescriptionCell
            if self.taskDictionary != nil {
                cell.descriptionLabel.text = self.taskDictionary![.description]![0] as? String
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CreateTaskReviewItemCell
        if self.taskDictionary != nil {
            cell.itemLabel.text = self.taskDictionary![.items]![indexPath.row - 1] as? String
        }
        return cell
    }
    
}
