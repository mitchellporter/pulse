//
//  ViewUpdateBreakdownViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class ViewUpdateBreakdownViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var datasource: [Response] = [Response]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }

    private func setupTableView() {
        self.tableView.dataSource = self
        let cell: UINib = UINib(nibName: "UpdateBreakdownTableViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "progressCell")
        self.tableView.contentInset = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
    }
    
    private func closeView() {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            guard let view: UIView = touch.view else { continue }
            if view.isDescendant(of: self.tableView) {
                return
            }
        }
        
        self.closeView()
    }
}

extension ViewUpdateBreakdownViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UpdateBreakdownTableViewCell = tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath) as? UpdateBreakdownTableViewCell else {
            return tableView.dequeueReusableCell(withIdentifier: "progressCell", for: indexPath)
        }
        cell.load(datasource[indexPath.row])
        return cell
    }
}
