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

enum TaskStatus: String {
    case pending = "pending"
    case inProgress = "in_progress"
    case completed = "completed"
}

extension Task {
    
    var taskStatus: TaskStatus {
        return TaskStatus(rawValue: self.status)!
    }
    
    var updateDaysEnum: [WeekDay]? {
        guard let updateDays = self.updateDays else { return nil }
        return updateDays.flatMap { return WeekDay(rawValue: $0) }
    }
    
    func mostRecentUpdate() -> Update? {
        return self.updatesSortedByRecency()?.first
    }
    
    func updatesSortedByRecency() -> [Update]? {
        guard let updates = self.updates else { return nil }
        return updates.sorted { $0.createdAt! > $1.createdAt! }
    }
}

extension Task: PulseType {
    typealias T = Task
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: "Task")
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
        if let createdAtTime = json["created_at"] as? String {
            createdAt = Date.from(createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? String {
            updatedAt = Date.from(updatedAtTime)
        }
        
        let title = json["title"] as! String
        let status = json["status"] as! String
        let updateDays = json["update_days"] as? [String]
        
        let completionPercentage = json["completion_percentage"] as? Float ?? 0.0
        
        var dueDate: Date?
        if let dueDateTime = json["due_date"] as? String {
            dueDate = Date.from(dueDateTime)
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
        task.updateDays = updateDays
        task.dueDate = dueDate
        task.completionPercentage = completionPercentage
        
        if let assigneesJSON = json["assignees"] as? [[String: AnyObject]] {
            assigneesJSON.forEach({ assigneeJSON in
                let assignee = User.from(json: assigneeJSON, context: context)
                task.addToAssignees(assignee)
            })
        }
        
        if let itemsJSON = json["items"] as? [[String: AnyObject]] {
            itemsJSON.forEach({ itemJSON in
                let item = Item.from(json: itemJSON,  context: context)
                task.addToItems(item)
            })
        }
        
        if let taskInvitationsJSON = json["invitations"] as? [[String: AnyObject]] {
            taskInvitationsJSON.forEach({ taskInvitationJSON in
                let taskInvitation = TaskInvitation.from(json: taskInvitationJSON,  context: context) as TaskInvitation
                task.addToInvitations(taskInvitation)
            })
        }
        
        if let updatesJSON = json["updates"] as? [[String: AnyObject]] {
            updatesJSON.forEach({ updateJSON in
                let update = Update.from(json: updateJSON,  context: context) as Update
                task.addToUpdates(update)
            })
        }
        
        return task
    }
}

