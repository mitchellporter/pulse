//
//  Item+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item");
    }

    @NSManaged public var completed: Bool
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var objectId: String
    @NSManaged public var status: String
    @NSManaged public var text: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var task: Task?

}
