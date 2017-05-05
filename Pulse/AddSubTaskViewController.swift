//
//  AddSubTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 5/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class AddSubTaskViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMenuBottomConstraint: NSLayoutConstraint!
    
    var items: Array = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    private func setupTableView() {
        let cell: UINib = UINib(nibName: "CreateTaskItemCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "CreateItemCell")
        let addItemCell: UINib = UINib(nibName: "CreateTaskAddItemCell", bundle: nil)
        self.tableView.register(addItemCell, forCellReuseIdentifier: "CreateAddItemCell")
        self.tableView.backgroundColor = self.view.backgroundColor
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.view.backgroundColor
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        guard let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect) else { return }
        guard let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let resigning: Bool = notification.name == .UIKeyboardWillHide
        let bottomSpace: CGFloat = resigning ? 0.0 : keyboardEndFrame.height
        
        UIView.animate(withDuration: keyboardDuration, delay: 0.0, options: [.curveLinear, .layoutSubviews], animations: {
            self.bottomMenuBottomConstraint.constant = bottomSpace
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func addNew(item: String) {
        self.items.insert(item, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
    }
    
    fileprivate func update(item: String, at indexPath: IndexPath) {
        self.items[indexPath.row - 1] = item
    }
    
    fileprivate func removeItem(at indexPath: IndexPath) {
        self.items.remove(at: indexPath.row - 1)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toUpdates", sender: nil)
    }
}

extension AddSubTaskViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell: CreateTaskAddItemCell = tableView.dequeueReusableCell(withIdentifier: "CreateAddItemCell", for: indexPath) as? CreateTaskAddItemCell else { return tableView.dequeueReusableCell(withIdentifier: "CreateAddItemCell", for: indexPath) }
            cell.delegate = self
            return cell
        }
        guard let cell: CreateTaskItemCell = tableView.dequeueReusableCell(withIdentifier: "CreateItemCell", for: indexPath) as? CreateTaskItemCell else { return tableView.dequeueReusableCell(withIdentifier: "CreateItemCell", for: indexPath) }
        cell.delegate = self
        cell.load(text: self.items[indexPath.row - 1], at: indexPath)
        return cell
    }
}

extension AddSubTaskViewController: CreateTaskItemCellDelegate, CreateTaskAddItemCellDelegate {
    
    func taskItem(cell: CreateTaskItemCell, didUpdate text: String) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { print("No index path for selected cell"); return }
        self.update(item: text, at: indexPath)
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func taskItem(cell: CreateTaskItemCell, remove item: String) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { print("No index path for selected cell"); return }
        self.removeItem(at: indexPath)
    }
    
    func cellNeedsResize(_ cell: UITableViewCell) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        self.tableView.reloadRows(at: [indexPath], with: .middle)
    }
    
    func addItemCell(_ cell: CreateTaskAddItemCell, addNew item: String) {
        self.addNew(item: item)
    }
    
    func addItemCell(cell: CreateTaskAddItemCell, didUpdateItem text: String) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func addItemCell(_ cell: CreateTaskAddItemCell, didUpdateDescription text: String) {
        //
    }
}
