//
//  UpdateService.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias UpdateRequestsSuccessCompletion = (_ updateRequests: [UpdateRequest]) -> Void

typealias UpdateSuccessCompletion = (_ update: Update) -> Void
typealias UpdatesSuccessCompletion = (_ updates: [Update]) -> Void

struct UpdateService {
    static func getUpdateRequests(offset: Int, success: @escaping UpdateRequestsSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getUpdateRequests(offset: offset), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let updateRequestsJSON = json["update_requests"].arrayObject {
                    var updateRequests = [UpdateRequest]()
                    updateRequestsJSON.forEach({ (updateRequestJSON) in
                        let updateRequest = UpdateRequest.from(json: updateRequestJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        updateRequests.append(updateRequest)
                    })
                    success(updateRequests)
                }
            }
        }, failure: failure)
    }
    
    static func getUpdates(updateRequestId: String, offset: Int, success: @escaping UpdatesSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getUpdates(updateRequestId: updateRequestId, offset: offset), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let updatesJSON = json["updates"].arrayObject {
                    var updates = [Update]()
                    updatesJSON.forEach({ (updateJSON) in
                        let update = Update.from(json: updateJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        updates.append(update)
                    })
                    success(updates)
                }
            }
        }, failure: failure)
    }
    
    static func sendTaskUpdate(taskId: String, completionPercentage: Float, success: @escaping UpdateSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .sendTaskUpdate(taskId: taskId, completionPercentage: completionPercentage), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let updateJSON = json["update"].dictionaryObject {
                    let update = Update.from(json: updateJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(update)
                }
            }
        }, failure: failure)
    }
}
