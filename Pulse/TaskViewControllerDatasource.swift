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
            }
        }
    }
    
    private func updatePredicate(for type: String) {
        let predicate = NSPredicate(format: "ANY projects.objectId == ")
        self.fetchedResultsController.fetchRequest.predicate = predicate
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TaskCell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as? TaskCell else {
            return tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        }
        return cell
    }

}
