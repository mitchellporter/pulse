//
//  TaskInvitation+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/4/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(TaskInvitation)
public class TaskInvitation: NSManagedObject {

}

enum TaskInvitationStatus: String {
    case pending
    case accepted
    case denied
}

extension TaskInvitation {
    
    var invitationStatus: TaskInvitationStatus {
        return TaskInvitationStatus(rawValue: self.status)!
    }
}

extension TaskInvitation: PulseType {
    typealias T = TaskInvitation
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest<T>(entityName: "TaskInvitation")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> TaskInvitation {
        let objectId = json["_id"] as! String
        
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? String {
            createdAt = Date.from(createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? String {
            updatedAt = Date.from(updatedAtTime)
        }
        
        let status = json["status"] as! String
        
        let description = NSEntityDescription.entity(forEntityName: "TaskInvitation", in: context)!
        let taskInvitation = TaskInvitation(entity: description, insertInto: context)
        taskInvitation.objectId = objectId
        taskInvitation.createdAt = createdAt
        taskInvitation.updatedAt = updatedAt
        taskInvitation.status = status
        
        if let taskJSON = json["task"] as? [String: AnyObject] {
            let task = Task.from(json: taskJSON, context: context) as Task
            taskInvitation.task = task
        }
        
        if let senderJSON = json["sender"] as? [String: AnyObject] {
            let sender = User.from(json: senderJSON, context: context) as User
            taskInvitation.sender = sender
        }
        
        if let receiverJSON = json["receiver"] as? [String: AnyObject] {
            let receiver = User.from(json: receiverJSON, context: context) as User
            taskInvitation.receiver = receiver
        }
        
        return taskInvitation
    }
}
