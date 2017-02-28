//
//  Update+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Update)
public class Update: NSManagedObject {

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
        
        let description = NSEntityDescription.entity(forEntityName: "Update", in: context)!
        let update = Update(entity: description, insertInto: context)
        update.objectId = objectId
        update.createdAt = createdAt
        update.updatedAt = updatedAt
        
        if let taskJSON = json["task"] as? [String: AnyObject] {
            let task = Task.from(json: taskJSON, context: context)
            update.task = task
        }
        
        if let senderJSON = json["sender"] as? [String: AnyObject] {
            let sender = User.from(json: senderJSON, context: context)
            update.sender = sender
        }
        
        if let receiversJSON = json["receivers"] as? [[String: AnyObject]] {
            receiversJSON.forEach({ receiverJSON in
                let receiver = User.from(json: receiverJSON, context: context)
                update.addToReceivers(receiver)
            })
        }
        
        return update
    }
}
