//
//  EditTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var backButton: Button!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateButton: Button!
    @IBOutlet weak var cancelButton: Button!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var tableViewTopInset: CGFloat = 22
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let viewCell: UINib = UINib(nibName: "TaskItemViewCell", bundle: nil)
        let editCell: UINib = UINib(nibName: "TaskItemEditCell", bundle: nil)
        self.tableView.register(viewCell, forCellReuseIdentifier: "taskItemViewCell")
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
    
    @IBAction func cencelButtonPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.editingTask = false
    }
}

extension EditTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier: String = "taskItemEditCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskItemEditCell else {
            return tableView.dequeueReusableCell(withIdentifier: "taskItemViewCell", for: indexPath)
        }
        
        cell.delegate = self
        cell.state = indexPath.row == 0 ? .selected : .unselected
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        return cell
    }
    
}

extension EditTaskViewController: TaskItemCellDelegate {
    
    func taskUpdated(item: String) {
        self.editingTask = true
    }
}
