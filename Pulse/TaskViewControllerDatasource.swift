//
//  TaskViewControllerDatasource.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class TaskViewControllerDatasource: NSObject, UITableViewDataSource {
    
    var fetchedResultsController: NSFetchedResultsController<Task>!
    var dataType: Int = 0 {
        didSet {
            if oldValue != self.dataType {
                
//                self.setupCoreData()
            }
        }
    }
    
    override init() {
        super.init()
        
//        self.setupCoreData()
    }
    
    private func setupCoreData() {
        let request: NSFetchRequest<Task> = Task.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType), sectionNameKeyPath: nil, cacheName: nil)
        // TODO
        self.updatePredicate(for: "")
    }
    
    private func updatePredicate(for type: String) {
        // TODO
        let predicate = NSPredicate(format: "ANY projects.objectId == ")
        self.fetchedResultsController.fetchRequest.predicate = predicate
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {
            return tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        }
        
        
        
        return cell
    }

}
