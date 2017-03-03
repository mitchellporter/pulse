//
//  ViewTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewTaskViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomMenu: UIView!
    @IBOutlet weak var backButton: Button!
    @IBOutlet weak var updateButton: Button!
    @IBOutlet weak var doneButton: Button!
    @IBOutlet weak var avatarImageView: UIImageView!

    var tableViewTopInset: CGFloat = 22
    
    var task: Task!
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
        self.setupCoreData()
        self.fetchData()
    }
    
    private func setupCoreData() {
        let fetchRequest: NSFetchRequest<Item> = Item.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        let predicate = NSPredicate(format: "task.objectId == %@", self.task.objectId)
        
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "status", cacheName: nil)
    }
    
    private func fetchData() {
        
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        TaskService.getTask(taskId: self.task.objectId, success: { (task) in
            CoreDataStack.shared.saveContext()
            
            do {
                try self.fetchedResultsController.performFetch()
                self.tableView.reloadData()
            } catch {
                print("fetched results controller error: \(error)")
            }
        }) { (error, statusCode) in
            // TODO: Handle failure
        }
    }
    
    private func setupAppearance() {
        let frame: CGRect = CGRect(x: 0, y: 120, width: UIScreen.main.bounds.width, height: self.tableViewTopInset)
        let topGradient: CAGradientLayer = CAGradientLayer()
        topGradient.frame = frame
        topGradient.colors = [mainBackgroundColor.withAlphaComponent(1.0).cgColor, mainBackgroundColor.withAlphaComponent(0.0).cgColor]
        topGradient.locations = [0.0, 1.0]
        
        self.view.layer.addSublayer(topGradient)
        
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
        
        self.view.backgroundColor = mainBackgroundColor
        self.avatarImageView.superview!.backgroundColor = self.view.backgroundColor
    }

    private func setupTableView() {
        self.tableView.backgroundColor = self.view.backgroundColor
        let cell: UINib = UINib(nibName: "TaskItemViewCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "itemViewCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 70
//        self.tableView.contentInset = UIEdgeInsets(top: self.tableViewTopInset, left: 0, bottom: 0, right: 0)
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemViewCell", for: indexPath) as! TaskItemViewCell
        let item = self.fetchedResultsController.object(at: indexPath)
        cell.load(item: item)
        cell.contentView.backgroundColor = self.tableView.backgroundColor
        return cell
    }
}
