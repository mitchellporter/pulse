//
//  Update+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/7/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData


extension Update {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update");
    }

    @NSManaged public var completionPercentage: Float
    @NSManaged public var createdAt: Date?
    @NSManaged public var objectId: String
    @NSManaged public var updatedAt: Date?
    @NSManaged public var sender: User?
    @NSManaged public var updateRequest: UpdateRequest?
    @NSManaged public var receiver: User?
    @NSManaged public var task: Task?

}
