//
//  TaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {
    
    enum ViewMode: Int {
        case myTasks
        case createdTasks
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: Button!
    
    @IBOutlet weak var myTasksButton: Button!
    @IBOutlet weak var createdTasksButton: Button!
    
    private var modeSelected: ViewMode = .myTasks {
        didSet {
            if oldValue != self.modeSelected {
                self.updateView(mode: self.modeSelected)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateView(mode: ViewMode) {
        switch mode {
        case .myTasks:
            self.myTasksButton.alpha = 1
            self.createdTasksButton.alpha = 0.3
        case .createdTasks:
            self.createdTasksButton.alpha = 1
            self.myTasksButton.alpha = 0.3
        }
    }

    @IBAction func myTasksPressed(_ sender: UIButton) {
        self.modeSelected = .myTasks
    }
    
    @IBAction func createdTasksPressed(_ sender: UIButton) {
        self.modeSelected = .createdTasks
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
}
