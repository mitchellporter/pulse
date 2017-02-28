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
    var fetchedResultsController: NSFetchedResultsController<Update>!

    override func viewDidLoad() {
        super.viewDidLoad()

        let request: NSFetchRequest<Update> = Update.createFetchRequest()
        let sort = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sort]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: "sender.id", cacheName: nil)
        
        // Predicate ???
//        let predicate = NSPredicate(format: "sender.id == %@ OR ANY receivers.id == %@", User.currentUserId(), User.currentUserId())
//        self.fetchedResultsController.fetchRequest.predicate = predicate
    }
}

extension UpdatesController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        _ = self.fetchedResultsController.object(at: indexPath)
        return cell
    }
}


