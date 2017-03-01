//
//  Update+CoreDataProperties.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Update {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update");
    }

    @NSManaged public var objectId: String
    @NSManaged public var createdAt: Date?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var completionPercentage: Float
    @NSManaged public var sender: User?
    @NSManaged public var updateRequest: UpdateRequest?

}
