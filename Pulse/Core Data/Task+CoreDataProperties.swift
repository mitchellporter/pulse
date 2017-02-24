//
//  Task+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task");
    }

    @NSManaged public var objectId: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var title: String
    @NSManaged public var dueDate: Date?
    @NSManaged public var update_day: String
    @NSManaged public var status: String
    @NSManaged public var assigner: User?
    @NSManaged public var assignees: NSSet
    @NSManaged public var items: NSSet

}

// MARK: Generated accessors for assignees
extension Task {

    @objc(addAssigneesObject:)
    @NSManaged public func addToAssignees(_ value: User)

    @objc(removeAssigneesObject:)
    @NSManaged public func removeFromAssignees(_ value: User)

    @objc(addAssignees:)
    @NSManaged public func addToAssignees(_ values: NSSet)

    @objc(removeAssignees:)
    @NSManaged public func removeFromAssignees(_ values: NSSet)

}

// MARK: Generated accessors for items
extension Task {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
