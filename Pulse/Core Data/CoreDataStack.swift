//
//  CoreDataStack.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack: NSObject {
    static let shared = CoreDataStack()
    private (set) var context: NSManagedObjectContext!
    
    private override init() {
        super.init()
        self.setup()
    }
    
    private func setup() {
        self.context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        // NOTE: This combined with our unique constraint for objectId fixes all dupe model issues
        self.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        let url = Bundle.main.url(forResource: "Pulse", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: url)!
        self.context.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            let store_url = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("db.sqlite")
            try self.context.persistentStoreCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: store_url, options: nil)
            
        } catch {
            print("core data setup error: \(error)")
        }
    }
    
    func saveContext() {
        // Only save if entities have changes
        guard self.context.hasChanges else { return }
        do {
            try self.context.save()
        } catch {
            print("core data save error: \(error)")
        }
    }
}

