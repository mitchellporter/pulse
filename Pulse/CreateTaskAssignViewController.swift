//
//  CreateTaskAssignViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskAssignViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var assignDescriptionLabel: UILabel!
    var taskDictionary: [CreateTaskKeys : [Any]]?
    var tableViewTopInset: CGFloat = 30
    
    var assignees: Set = Set<String>() {
        didSet {
            var assigneesArray: [String] = [String]()
            assigneesArray.append(contentsOf: self.assignees)
            _ = self.taskDictionary?.updateValue(assigneesArray, forKey: CreateTaskKeys.assignees)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParentViewController || self.isBeingDismissed {
            print("dismissing!")
            guard let previousViewController: CreateTaskDateViewController = NavigationManager.getPreviousViewController(CreateTaskDateViewController.self, from: self) as? CreateTaskDateViewController else { return }
            guard let taskDictionary = self.taskDictionary else { return }
            previousViewController.taskDictionary = taskDictionary
        } else {
            print("not dismissing!")
        }
    }
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: (self.assignDescriptionLabel.frame.origin.y + self.assignDescriptionLabel.frame.height), width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [createTaskBackgroundColor.cgColor, createTaskBackgroundColor.withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        self.view.backgroundColor = createTaskBackgroundColor
    }
    
    private func setupTableView() {
        let cell: UINib = UINib(nibName: "CreateTaskAssignCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "assignCell")
        self.tableView.rowHeight = 58
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
        self.tableView.backgroundColor = self.view.backgroundColor
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "updates", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dictionary = self.taskDictionary else { return }
        guard let toVC = segue.destination as? CreateTaskUpdatesViewController else { return }
        toVC.taskDictionary = dictionary
    }

}

extension CreateTaskAssignViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignCell", for: indexPath) as! CreateTaskAssignCell
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        cell.delegate = self
        return cell
    }
}

extension CreateTaskAssignViewController: CreateTaskAssignCellDelegate {
    
    func selectedAssignCell(_ cell: CreateTaskAssignCell) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        _ = indexPath
        guard let user: String = cell.user?.objectId else { return }
        if self.assignees.contains(user) {
            self.assignees.remove(user)
        } else {
            self.assignees.insert(user)
        }
    }
}
