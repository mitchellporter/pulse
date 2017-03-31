//
//  SendTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class SendTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    fileprivate var emailDatasource: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
    }
    
    func setupAppearance() {
        self.sendButton.layer.cornerRadius = 3.0
    }
    
    func setupTableView() {
        let emailCell: UINib = UINib(nibName: "SendTaskEmailCell", bundle: nil)
        self.tableView.register(emailCell, forCellReuseIdentifier: "emailCell")
        let sendTaskCell: UINib = UINib(nibName: "SendTaskCell", bundle: nil)
        self.tableView.register(sendTaskCell, forCellReuseIdentifier: "sendTaskCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 74
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension SendTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emailDatasource.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == self.emailDatasource.count {
            let cell: SendTaskEmailCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! SendTaskEmailCell
            cell.contentView.backgroundColor = tableView.backgroundColor
            return cell
        } else if indexPath.row == self.emailDatasource.count + 1 {
            let cell: SendTaskCell = tableView.dequeueReusableCell(withIdentifier: "sendTaskCell", for: indexPath) as! SendTaskCell
            cell.contentView.backgroundColor = tableView.backgroundColor
            return cell
        }
        let cell: SendTaskEmailCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! SendTaskEmailCell
        cell.contentView.backgroundColor = tableView.backgroundColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.emailDatasource.count + 1 {
            self.performSegue(withIdentifier: "addressBook", sender: nil)
        }
    }
}
