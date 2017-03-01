//
//  UpdatesController.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class UpdatesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<UpdateRequest>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        let request: NSFetchRequest<UpdateRequest> = UpdateRequest.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "senderIsCurrentUser", cacheName: nil)
        
        // Predicate ???
//        let predicate = NSPredicate(format: "sender.objectId == %@ OR ANY receivers.objectId == %@", User.currentUserId(), User.currentUserId())
//        self.fetchedResultsController.fetchRequest.predicate = predicate
        
        self.fetchUpdates()
    }
    
    func fetchUpdates() {
        do {
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            print("fetched results controller error: \(error)")
        }
        
        UpdateService.getUpdates(offset: 0, success: { (updates) in
            
            print("fetched updates: \(updates.count)")
            
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
}

extension UpdatesController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("sections: \(self.fetchedResultsController.sections?.count ?? 1)")
        return self.fetchedResultsController.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section]
        print("section name: \(sectionInfo.name)")
        print(sectionInfo)
        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        print("number of objects: \(sectionInfo.numberOfObjects)")
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let update = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = update.sender?.name
        return cell
    }
}


