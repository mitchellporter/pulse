//
//  FeedService.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FeedService {
    static func getUpdatesFeed(success: @escaping UpdatesSuccessCompletion, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getUpdatesFeed, success: { (data) in
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
