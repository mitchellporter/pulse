//
//  User+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var avatarURL: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String
    @NSManaged public var objectId: String
    @NSManaged public var position: String
    @NSManaged public var updatedAt: Date?
    @NSManaged public var createdTasks: NSSet?
    @NSManaged public var receivedTasks: NSSet?
    @NSManaged public var requestedUpdates: NSSet?
    @NSManaged public var sentUpdates: NSSet?
    @NSManaged public var team: Team?

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

// MARK: Generated accessors for receivedTasks
extension User {

    @objc(addReceivedTasksObject:)
    @NSManaged public func addToReceivedTasks(_ value: Task)

    @objc(removeReceivedTasksObject:)
    @NSManaged public func removeFromReceivedTasks(_ value: Task)

    @objc(addReceivedTasks:)
    @NSManaged public func addToReceivedTasks(_ values: NSSet)

    @objc(removeReceivedTasks:)
    @NSManaged public func removeFromReceivedTasks(_ values: NSSet)

}

// MARK: Generated accessors for requestedUpdates
extension User {

    @objc(addRequestedUpdatesObject:)
    @NSManaged public func addToRequestedUpdates(_ value: Update)

    @objc(removeRequestedUpdatesObject:)
    @NSManaged public func removeFromRequestedUpdates(_ value: Update)

    @objc(addRequestedUpdates:)
    @NSManaged public func addToRequestedUpdates(_ values: NSSet)

    @objc(removeRequestedUpdates:)
    @NSManaged public func removeFromRequestedUpdates(_ values: NSSet)

}

// MARK: Generated accessors for sentUpdates
extension User {

    @objc(addSentUpdatesObject:)
    @NSManaged public func addToSentUpdates(_ value: Update)

    @objc(removeSentUpdatesObject:)
    @NSManaged public func removeFromSentUpdates(_ value: Update)

    @objc(addSentUpdates:)
    @NSManaged public func addToSentUpdates(_ values: NSSet)

    @objc(removeSentUpdates:)
    @NSManaged public func removeFromSentUpdates(_ values: NSSet)

}
