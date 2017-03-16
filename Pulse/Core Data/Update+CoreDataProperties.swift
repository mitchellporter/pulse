//
//  Update+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Update {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update");
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var objectId: String
    @NSManaged public var updatedAt: Date?
    @NSManaged public var type: String?
    @NSManaged public var task: Task
    @NSManaged public var responses: NSSet?
    @NSManaged public var taskAssignerIsCurrentUser: Bool
}

// MARK: Generated accessors for responses
extension Update {

    @objc(addResponsesObject:)
    @NSManaged public func addToResponses(_ value: Response)

    @objc(removeResponsesObject:)
    @NSManaged public func removeFromResponses(_ value: Response)

    @objc(addResponses:)
    @NSManaged public func addToResponses(_ values: NSSet)

    @objc(removeResponses:)
    @NSManaged public func removeFromResponses(_ values: NSSet)

}
