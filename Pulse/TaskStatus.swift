//
//  TaskStatus.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation

enum TaskStatus: String {
    case pending
    case needsUpdate
    case updated
    case due
    case inProgress = "in_progress"
    case completed
}
