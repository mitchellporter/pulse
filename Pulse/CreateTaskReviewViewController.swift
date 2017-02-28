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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    private func setupTableView() {
        let descriptionCell: UINib = UINib(nibName: "CreateTaskReviewDescriptionCell", bundle: nil)
        self.tableView.register(descriptionCell, forCellReuseIdentifier: "descriptionCell")
        let itemCell: UINib = UINib(nibName: "CreateTaskReviewItemCell", bundle: nil)
        self.tableView.register(itemCell, forCellReuseIdentifier: "itemCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 45
        self.tableView.dataSource = self
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! CreateTaskReviewDescriptionCell
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! CreateTaskReviewItemCell
        
        return cell
    }
    
}
