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
    
    var tableViewTopInset: CGFloat = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.setupTableView()
    }
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: (self.assignDescriptionLabel.frame.origin.y + self.assignDescriptionLabel.frame.height), width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [UIColor("1AB17CFF").cgColor, UIColor("1AB17C00").cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
    }
    
    private func setupTableView() {
        let cell: UINib = UINib(nibName: "CreateTaskAssignCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "assignCell")
        self.tableView.rowHeight = 58
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
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

}

extension CreateTaskAssignViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignCell", for: indexPath)
        
        return cell
    }
}

extension CreateTaskAssignViewController: CreateTaskAssignCellDelegate {
    
    func selectedAssignCell(_ cell: CreateTaskAssignCell) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        _ = indexPath
    }
}
