//
//  Invite+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Invite)
public class Invite: NSManagedObject {

}

extension Invite: PulseType {
    typealias T = Invite
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "Invite")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Invite {
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
        let status = json["status"] as! String
        
        let description = NSEntityDescription.entity(forEntityName: "Invite", in: context)!
        let invite = Invite(entity: description, insertInto: context)
        invite.objectId = objectId
        invite.createdAt = createdAt
        invite.updatedAt = updatedAt
        invite.type = type
        invite.status = status
        
        if let senderJSON = json["sender"] as? [String: AnyObject] {
            let sender = User.from(json: senderJSON, context: context)
            invite.sender = sender
        }
        
        if let teamJSON = json["team"] as? [String: AnyObject] {
            let team = Team.from(json: teamJSON, context: context)
            invite.team = team
        }
        
        if let taskJSON = json["task"] as? [String: AnyObject] {
            let task = Task.from(json: taskJSON, context: context)
            invite.task = task
        }
        return invite
    }
}
