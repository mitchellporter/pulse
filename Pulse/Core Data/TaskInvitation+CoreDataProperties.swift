//
//  TaskInvitation+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/4/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension TaskInvitation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskInvitation> {
        return NSFetchRequest<TaskInvitation>(entityName: "TaskInvitation");
    }

    @NSManaged public var objectId: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var task: Task?
    @NSManaged public var sender: User?
    @NSManaged public var receiver: User?

}
