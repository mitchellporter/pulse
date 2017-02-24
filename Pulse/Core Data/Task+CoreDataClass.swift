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
    
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Task {
        let description = NSEntityDescription.entity(forEntityName: "Task", in: context)!
        
        let objectId = json["_id"] as! String
        
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? Double {
            createdAt = Date(timeIntervalSince1970: createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? Double {
            updatedAt = Date(timeIntervalSince1970: updatedAtTime)
        }
        
        let title = json["title"] as! String
        let status = json["status"] as! String
        let update_day = json["update_day"] as! String
        let completionPercentage = json["completion_percentage"] as? Float ?? 0.0
        
        var dueDate: Date?
        if let dueDateTime = json["due_date"] as? Double {
            dueDate = Date(timeIntervalSince1970: dueDateTime)
        }
        
        var assigner: User?
        if let assignerJSON = json["assigner"] as? [String: AnyObject] {
            assigner = User.from(json: assignerJSON, context: context) as User
        }
        
        let task = Task(entity: description, insertInto: context)
        task.objectId = objectId
        task.createdAt = createdAt
        task.updatedAt = updatedAt
        task.assigner = assigner
        task.title = title
        task.status = status
        task.update_day = update_day
        task.dueDate = dueDate
        
        // TODO: Set completion percentage
        // task.completionPercentage = completionPercentage
        
        
        if let assigneesJSON = json["assignees"] as? [[String: AnyObject]] {
            assigneesJSON.forEach({ assigneeJSON in
                let assignee = User.from(json: assigneeJSON, context: context)
                task.addToAssignees(assignee)
            })
        }
        
        if let itemsJSON = json["items"] as? [[String: AnyObject]] {
            itemsJSON.forEach({ itemJSON in
                let item = Item.from(json: itemJSON, context: context)
                task.addToItems(item)
            })
        }
        
        return task
    }
}
