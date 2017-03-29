//
//  TeamViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/29/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import CoreData

class TeamViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<User>!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupCoreData()
        self.setupTableView()
        self.fetchData()
    }
    
    private func setupCoreData() {
        let fetchRequest: NSFetchRequest<User> = User.createFetchRequest()
        let sortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController: NSFetchedResultsController<User> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController = fetchedResultsController
    }
    
    private func setupTableView() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cel")
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func getCurrentUser() -> User? {
        let fetchRequest: NSFetchRequest<User> = User.createFetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "objectId == %@", User.currentUserId())
        fetchRequest.predicate = predicate
        
        do {
            let result = try CoreDataStack.shared.context.fetch(fetchRequest)
            if result.count == 1 {
                return result[0]
            }
            return nil
        } catch {
            print("No team available")
            return nil
        }
    }
    
    private func fetchData() {
        self.checkCache()
        guard let user: User = self.getCurrentUser() else { return }
        guard let team: Team = user.team else { return }
        TeamService.getTeamMembers(teamId: team.objectId, offset: 0, success: { (users) in
            // If this is not put before saveContext, then animation is still visible and FRC delegate methods get called
            self.fetchedResultsController.delegate = nil
            CoreDataStack.shared.saveContext()
            self.checkCache()
        }) { (error, statusCode) in
            print("Error getting users: \(statusCode ?? 000) \(error.localizedDescription)")
        }
    }
    
    private func checkCache() {
        // Check cache
        do {
            try self.fetchedResultsController.performFetch()
            self.fetchedResultsController.delegate = self
        } catch {
            print("Fetched results controller error: \(error)")
        }
        self.tableView.reloadData()
    }
}

extension TeamViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cel", for: indexPath)
        guard let item: User = self.fetchedResultsController.fetchedObjects?[indexPath.row] else { return cell }
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Do something
    }
}

extension TeamViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.tableView.insertSections([sectionIndex], with: .fade)
        case .delete:
            self.tableView.deleteSections([sectionIndex], with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath: IndexPath = newIndexPath else { return }
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        case .delete:
            guard let indexPath: IndexPath = indexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath: IndexPath = indexPath else { return }
            if let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell {
                cell.load(anObject, type: .createdTask)
            }
        case .move:
            guard let indexPath: IndexPath = indexPath else { return }
            guard let newIndexPath: IndexPath = newIndexPath else { return }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}
