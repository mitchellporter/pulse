//
//  UpdateService.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias UpdatesSuccessCompletion = (_ updates: [Update]) -> Void

struct UpdateService {
    static func getUpdates(offset: Int, success: @escaping UpdatesSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getUpdates(offset: offset), success: { (data) in
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
}
