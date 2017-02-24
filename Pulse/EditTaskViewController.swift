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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupTableView() {
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
}

extension EditTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item: Item = Item()
        item.completed = true
        let identifier: String = item.completed == true ? "taskItemViewCell" : "taskItemEditCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskItemCell else {
            return tableView.dequeueReusableCell(withIdentifier: "taskItemViewCell", for: indexPath)
        }
        
        cell.delegate = self
        
        return cell as! UITableViewCell
    }
    
}

extension EditTaskViewController: TaskItemCellDelegate {
    
    func taskUpdated(item: Item) {
        
    }
}
