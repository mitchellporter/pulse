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
        return Item(entity: description, insertInto: context)
    }
}
