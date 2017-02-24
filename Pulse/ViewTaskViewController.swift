//
//  ViewTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class ViewTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var backButton: Button!
    @IBOutlet weak var updateButton: Button!
    @IBOutlet weak var doneButton: Button!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupTableView() {
        let cell: UINib = UINib(nibName: "TaskItemViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "itemViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        self.tableView.dataSource = self
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskItemViewCell = tableView.dequeueReusableCell(withIdentifier: "itemViewCell", for: indexPath) as? TaskItemViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "itemViewCell", for: indexPath)
        }
        
        return cell
    }
    
}
