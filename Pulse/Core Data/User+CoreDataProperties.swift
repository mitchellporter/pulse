//
//  User+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var objectId: String
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var name: String
    @NSManaged public var avatarURL: String
    @NSManaged public var position: String
    @NSManaged public var createdTasks: NSSet
    @NSManaged public var receivedTasks: NSSet

}

// MARK: Generated accessors for createdTasks
extension User {

    @objc(addCreatedTasksObject:)
    @NSManaged public func addToCreatedTasks(_ value: Task)

    @objc(removeCreatedTasksObject:)
    @NSManaged public func removeFromCreatedTasks(_ value: Task)

    @objc(addCreatedTasks:)
    @NSManaged public func addToCreatedTasks(_ values: NSSet)

    @objc(removeCreatedTasks:)
    @NSManaged public func removeFromCreatedTasks(_ values: NSSet)

}

// MARK: Generated accessors for assignedTasks
extension User {

    @objc(addAssignedTasksObject:)
    @NSManaged public func addToAssignedTasks(_ value: Task)

    @objc(removeAssignedTasksObject:)
    @NSManaged public func removeFromAssignedTasks(_ value: Task)

    @objc(addAssignedTasks:)
    @NSManaged public func addToAssignedTasks(_ values: NSSet)

    @objc(removeAssignedTasks:)
    @NSManaged public func removeFromAssignedTasks(_ values: NSSet)

}
