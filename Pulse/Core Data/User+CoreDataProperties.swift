//
//  User+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/16/17.
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
    @NSManaged public var name: String
    @NSManaged public var email: String
    @NSManaged public var objectId: String
    @NSManaged public var position: String
    @NSManaged public var updatedAt: Date?
    @NSManaged public var createdTasks: NSSet?
    @NSManaged public var receivedTaskInvitations: NSSet?
    @NSManaged public var receivedTasks: NSSet?
    @NSManaged public var sentTaskInvitations: NSSet?
    @NSManaged public var team: Team?
    @NSManaged public var responses: Set<Response>?

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

// MARK: Generated accessors for receivedTaskInvitations
extension User {

    @objc(addReceivedTaskInvitationsObject:)
    @NSManaged public func addToReceivedTaskInvitations(_ value: TaskInvitation)

    @objc(removeReceivedTaskInvitationsObject:)
    @NSManaged public func removeFromReceivedTaskInvitations(_ value: TaskInvitation)

    @objc(addReceivedTaskInvitations:)
    @NSManaged public func addToReceivedTaskInvitations(_ values: NSSet)

    @objc(removeReceivedTaskInvitations:)
    @NSManaged public func removeFromReceivedTaskInvitations(_ values: NSSet)

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

// MARK: Generated accessors for sentTaskInvitations
extension User {

    @objc(addSentTaskInvitationsObject:)
    @NSManaged public func addToSentTaskInvitations(_ value: TaskInvitation)

    @objc(removeSentTaskInvitationsObject:)
    @NSManaged public func removeFromSentTaskInvitations(_ value: TaskInvitation)

    @objc(addSentTaskInvitations:)
    @NSManaged public func addToSentTaskInvitations(_ values: NSSet)

    @objc(removeSentTaskInvitations:)
    @NSManaged public func removeFromSentTaskInvitations(_ values: NSSet)

}

// MARK: Generated accessors for responses
extension User {

    @objc(addResponsesObject:)
    @NSManaged public func addToResponses(_ value: Response)

    @objc(removeResponsesObject:)
    @NSManaged public func removeFromResponses(_ value: Response)

    @objc(addResponses:)
    @NSManaged public func addToResponses(_ values: NSSet)

    @objc(removeResponses:)
    @NSManaged public func removeFromResponses(_ values: NSSet)

}
