//
//  AvailabilityService.swift
//  Pulse
//
//  Created by Mitchell Porter on 3/22/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AvailabilityService {
    static func checkTeamAvailability(teamName: String, success: @escaping (_ available: Bool, _ teamName: String) -> Void, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .checkTeamNameAvailability(teamName: teamName), success: { (data) in
            let json = JSON(data: data)
            if let available = json["success"].bool {
                if let teamName = json["team_name"].string {
                    success(available, teamName)
                }
            }
        }, failure: failure)
    }
    
    static func checkEmailAvailability(email: String, success: @escaping (_ available: Bool, _ email: String) -> Void, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .checkEmailAvailability(email: email), success: { (data) in
            let json = JSON(data: data)
            if let available = json["success"].bool {
                if let email = json["email"].string {
                    success(available, email)
                }
            }
        }, failure: failure)
    }
}
