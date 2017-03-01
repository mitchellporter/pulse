//
//  User+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }

    @NSManaged public var avatarURL: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var name: String?
    @NSManaged public var objectId: String
    @NSManaged public var position: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var createdTasks: NSSet?
    @NSManaged public var receivedTasks: NSSet?
    @NSManaged public var sentUpdateRequests: NSSet?
    @NSManaged public var team: Team?
    @NSManaged public var receivedUpdateRequests: NSSet?

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

// MARK: Generated accessors for sentUpdateRequests
extension User {

    @objc(addSentUpdateRequestsObject:)
    @NSManaged public func addToSentUpdateRequests(_ value: UpdateRequest)

    @objc(removeSentUpdateRequestsObject:)
    @NSManaged public func removeFromSentUpdateRequests(_ value: UpdateRequest)

    @objc(addSentUpdateRequests:)
    @NSManaged public func addToSentUpdateRequests(_ values: NSSet)

    @objc(removeSentUpdateRequests:)
    @NSManaged public func removeFromSentUpdateRequests(_ values: NSSet)

}

// MARK: Generated accessors for receivedUpdateRequests
extension User {

    @objc(addReceivedUpdateRequestsObject:)
    @NSManaged public func addToReceivedUpdateRequests(_ value: UpdateRequest)

    @objc(removeReceivedUpdateRequestsObject:)
    @NSManaged public func removeFromReceivedUpdateRequests(_ value: UpdateRequest)

    @objc(addReceivedUpdateRequests:)
    @NSManaged public func addToReceivedUpdateRequests(_ values: NSSet)

    @objc(removeReceivedUpdateRequests:)
    @NSManaged public func removeFromReceivedUpdateRequests(_ values: NSSet)

}
