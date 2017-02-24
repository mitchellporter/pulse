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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupTableView() {
        let cell: UINib = UINib(nibName: "TaskItemCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "itemCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        
        self.tableView.dataSource = self
    }
    
}

extension ViewTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskItemCell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? TaskItemCell else {
            return tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        }
        
        return cell
    }
    
}
