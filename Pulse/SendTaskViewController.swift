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
    
    var task: Task?
    fileprivate var emailDatasource: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
    }
    
    func setupAppearance() {
        self.sendButton.layer.cornerRadius = 3.0
        self.sendButtonEnabled(false)
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
    
    fileprivate func sendButtonEnabled(_ enabled: Bool) {
        UIView.animate(withDuration: 0.1, animations: { 
            self.sendButton.alpha = enabled ? 1.0 : 0.34
        }) { _ in
            self.sendButton.isEnabled = enabled
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        guard let task: Task = self.task else { return }
        
        var emailArray: [[String : AnyObject]] = []
        for email in self.emailDatasource {
            let dictionary: [String : AnyObject] = ["name" : "" as AnyObject, "email" : email as AnyObject]
            emailArray.append(dictionary)
        }
        InviteService.inviteContactsToTask(taskId: task.objectId, contacts: emailArray, success: { (invite) in
            
            self.performSegue(withIdentifier: "endCreateFlow", sender: nil)
            
        }) { (error, statusCode) in
            print("Error: \(statusCode ?? 000) \(error.localizedDescription)")
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addressBook" {
            guard let task: Task = sender as? Task else { return }
            guard let toVC: AddressBookViewController = segue.destination as? AddressBookViewController else { return }
            toVC.task = task
        }
    }
    
    fileprivate func addCellFor(_ text: String, at indexPath: IndexPath) {
        if self.emailDatasource.count == indexPath.row {
            
            self.emailDatasource.append(text)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: self.emailDatasource.count, section: 0)], with: .fade)
            self.tableView.endUpdates()
            
        } else {
            
            self.emailDatasource[indexPath.row] = text
            
        }
    }
    
    fileprivate func removeCellFor(_ email: String, at indexPath: IndexPath) {
        if indexPath.row != self.emailDatasource.count {
            self.emailDatasource.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.endUpdates()
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
            cell.delegate = self
            return cell
        } else if indexPath.row == self.emailDatasource.count + 1 {
            let cell: SendTaskCell = tableView.dequeueReusableCell(withIdentifier: "sendTaskCell", for: indexPath) as! SendTaskCell
            cell.contentView.backgroundColor = tableView.backgroundColor
            return cell
        }
        let cell: SendTaskEmailCell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath) as! SendTaskEmailCell
        cell.contentView.backgroundColor = tableView.backgroundColor
        cell.emailTextField.text = self.emailDatasource[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.emailDatasource.count + 1 {
            guard let task: Task = self.task else { return }
            self.performSegue(withIdentifier: "addressBook", sender: task)
        }
    }
}

extension SendTaskViewController: SendTaskEmailCellDelegate {
    
    func sendTaskEmailCell(_ cell: SendTaskEmailCell, didChangeText text: String?) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        guard let email: String = text else { return }
        
        if email.contains(".") && email.contains("@") {
            self.sendButtonEnabled(true)
            self.addCellFor(email, at: indexPath)
        } else {
            self.sendButtonEnabled(false)
            
            if email == "" {
                self.removeCellFor(email, at: indexPath)
            }
        }
    }
}
