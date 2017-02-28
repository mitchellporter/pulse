//
//  CreateTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var taskDescription: String = "" {
        didSet {
            self.toggleNextButton()
        }
    }
    var taskItems: [String] = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupTableView()
        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupAppearance() {
        self.toggleNextButton()
        let frame: CGRect = CGRect(x: 0, y: 48, width: UIScreen.main.bounds.width, height: 32)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [UIColor("1AB17CFF").cgColor, UIColor("1AB17C00").cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
    }
    
    private func setupTableView() {
        let addCell: UINib = UINib(nibName: "CreateTaskAddItemCell", bundle: nil)
        self.tableView.register(addCell, forCellReuseIdentifier: "CreateAddItemCell")
        let cell: UINib = UINib(nibName:    "CreateTaskItemCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "CreateItemCell")
        self.tableView.estimatedRowHeight = 70
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func addNew(item: String) {
        self.taskItems.insert(item, at: 0)
        self.tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
    }
    
    fileprivate func removeItem(at indexPath: IndexPath) {
        self.taskItems.remove(at: indexPath.row - 1)
        self.tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    fileprivate func update(item: String, at indexPath: IndexPath) {
        self.taskItems[indexPath.row - 1] = item
    }
    
    private func toggleNextButton() {
        UIView.animate(withDuration: 0.1, animations: {
            if self.taskDescription != "" && self.taskDescription != kCreateTaskDescriptionPlaceholder {
                self.nextButton.alpha = 1
            } else {
                self.nextButton.alpha = 0
            }
        })
    }

    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // Pass the current description and items forward.
        
        self.performSegue(withIdentifier: "date", sender: nil)
    }

}

extension CreateTaskViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.taskItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: CreateTaskAddItemCell = tableView.dequeueReusableCell(withIdentifier: "CreateAddItemCell", for: indexPath) as! CreateTaskAddItemCell
            cell.delegate = self
            return cell
        }
        let cell: CreateTaskItemCell = tableView.dequeueReusableCell(withIdentifier: "CreateItemCell", for: indexPath) as! CreateTaskItemCell
        cell.load(text: self.taskItems[indexPath.row - 1], at: indexPath)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        
        return true
    }
}

extension CreateTaskViewController: CreateTaskItemCellDelegate, CreateTaskAddItemCellDelegate {
    
    func taskItem(cell: CreateTaskItemCell, didUpdate text: String) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { print("No index path for selected cell"); return }
        self.update(item: text, at: indexPath)
    }
    
    func taskItem(cell: CreateTaskItemCell, remove item: String) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { print("No index path for selected cell"); return }
        self.removeItem(at: indexPath)
    }
    
    func addItemCell(_ cell: CreateTaskAddItemCell, didUpdateDescription text: String) {
        self.taskDescription = text
    }
    
    func addItemCell(_ cell: CreateTaskAddItemCell, addNew item: String) {
        self.addNew(item: item)
    }
}
