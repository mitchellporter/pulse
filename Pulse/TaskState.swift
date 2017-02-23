//
//  TaskState.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation

enum TaskState: Int {
    case new
    case needsUpdate
    case updated
    case due
    case inProgress
    case completed
}
