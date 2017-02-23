//
//  Task+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

}

extension Task {
    enum TaskStatus: String {
        case pending
        case inProgress = "in_progress"
        case completed
    }
    
    var taskStatus: TaskStatus {
        return TaskStatus(rawValue: self.status)!
    }
}

extension Task: PulseType {
    typealias T = Task
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "Task")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    // TODO: Implement
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Task {
        let description = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        return Task(entity: description, insertInto: context)
    }
}
