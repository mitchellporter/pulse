//
//  User+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {

}

extension User: PulseType {
    typealias T = User
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "User")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    // TODO: Implement
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> User {
        let objectId = json["_id"] as! String
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? Double {
            createdAt = Date(timeIntervalSince1970: createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? Double {
            updatedAt = Date(timeIntervalSince1970: updatedAtTime)
        }
        
        let name = json["name"] as! String
        let position = json["position"] as! String
        let avatarURL = json["avatar_url"] as! String
        
        let user = User(entity: NSEntityDescription.entity(forEntityName: "User", in: context)!, insertInto: context)
        user.objectId = objectId
        user.createdAt = createdAt
        user.updatedAt = updatedAt
        user.name = name
        user.position = position
        user.avatarURL = avatarURL
        
        if let teamJSON = json["team"] as? [String: AnyObject] {
            let team = Team.from(json: teamJSON, context: context) as Team
            user.team = team
        }
        
        // TODO: No current use for both of these
        if let createdTasksJSON = json["created_tasks"] as? [[String: AnyObject]] {
            createdTasksJSON.forEach({ createdTaskJSON in
                let task = Task.from(json: createdTaskJSON, context: context) as Task
                user.addToCreatedTasks(task)
            })
        }
        
        if let assignedTasksJSON = json["received_tasks"] as? [[String: AnyObject]] {
            assignedTasksJSON.forEach({ assignedTaskJSON in
                let task = Task.from(json: assignedTaskJSON, context: context) as Task
                user.addToAssignedTasks(task)
            })
        }
        
        return user
    }
}
