//
//  Item+CoreDataClass.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {

}

enum ItemStatus: String {
    case inProgress = "in_progress"
    case completed
}

extension Item {
    var itemStatus: ItemStatus {
        return ItemStatus(rawValue: self.status)!
    }
}

extension Item: PulseType {
    typealias T = Item
    
    static func createFetchRequest<T>() -> NSFetchRequest<T> {
        return NSFetchRequest(entityName: "Item")
    }
    
    // TODO: Implement
    func toJSON() -> [String : AnyObject] {
        return [String: AnyObject]()
    }
    
    // TODO: Implement
    static func from(json: [String : AnyObject], context: NSManagedObjectContext) -> Item {
        let description = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        
        let objectId = json["_id"] as! String
        let text = json["text"] as! String
        let status = json["status"] as! String
        let completed = false
        
        let item = Item(entity: description, insertInto: context)
        item.objectId = objectId
        item.text = text
        item.status = status
        item.completed = completed
        
        if let taskJSON = json["task"] as? [String: AnyObject] {
            item.task = Task.from(json: taskJSON, context: context)
        }

        return item
    }
}
