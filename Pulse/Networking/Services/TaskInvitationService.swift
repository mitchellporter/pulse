//
//  TaskInvitationService.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/7/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias TaskInvitationSuccess = (_ taskInvitation: TaskInvitation) -> Void

struct TaskInvitationService {
    // TODO: You don't need the taskId for responses
    static func respondToTaskInvitation(taskInvitationId: String, status: TaskInvitationStatus, success: @escaping TaskInvitationSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .respondToTaskInvitation(taskInvitationId: taskInvitationId, status: status), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskInvitationJSON = json["task_invitation"].dictionaryObject {
                    let taskInvitation = TaskInvitation.from(json: taskInvitationJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(taskInvitation)
                }
            }
        }, failure: failure)
    }
}
