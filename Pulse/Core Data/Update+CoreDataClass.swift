//
//  Update+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Update)
public class Update: NSManagedObject {

}

extension Update {
    var mostRecentResponse: Response? {
        return self.responsesSortedByRecency()?.first
    }
    
    func responsesSortedByRecency() -> [Response]? {
        guard let responses = self.responses else { return nil }
        return responses.sorted { $0.createdAt! > $1.createdAt! }
    }
}

extension Update: PulseType {
    typealias T = Update
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "Update")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Update {
        let objectId = json["_id"] as! String
        
        var createdAt: Date?
        var updatedAt: Date?
        if let createdAtTime = json["created_at"] as? String {
            createdAt = Date.from(createdAtTime)
        }
        if let updatedAtTime = json["updated_at"] as? String {
            updatedAt = Date.from(updatedAtTime)
        }
        
        let type = json["type"] as! String
        
        let description = NSEntityDescription.entity(forEntityName: "Update", in: context)!
        let update = Update(entity: description, insertInto: context)
        update.objectId = objectId
        update.createdAt = createdAt
        update.updatedAt = updatedAt
        update.type = type
        
        if let taskJSON = json["task"] as? [String: AnyObject] {
            let task = Task.from(json: taskJSON, context: context)
            update.task = task
            
            update.taskAssignerIsCurrentUser = User.currentUser()!.objectId == task.assigner!.objectId
        }
        
        var requiresResponseFromCurrentUser = false
        if let responsesJSON = json["responses"] as? [[String: AnyObject]] {
            responsesJSON.forEach { responseJSON in
                let response = Response.from(json: responseJSON, context: context)
                update.addToResponses(response)
                
                // Check if update has response that requires update from current user
                // This helps filtering via FRC in updates feed
                if let assignee = response.assignee {
                    if assignee.objectId == User.currentUser()!.objectId && response.status == "requested" {
                        requiresResponseFromCurrentUser = true
                    }
                }
            }
        }
        update.requiresResponseFromCurrentUser = requiresResponseFromCurrentUser
    
        return update
    }
}
