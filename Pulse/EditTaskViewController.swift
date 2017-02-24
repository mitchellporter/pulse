//
//  EditTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupTableView() {
        
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
