//
//  PulseType.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import CoreData

protocol PulseType {
    associatedtype T
    func toJSON() -> [String: AnyObject]
    static func createFetchRequest<T>() -> NSFetchRequest<T>
    static func from(json: [String: AnyObject], context: NSManagedObjectContext) -> T
}
