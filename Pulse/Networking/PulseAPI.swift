//
//  PulseAPI.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation

enum WeekDay: String {
    case monday
    case wednesday
    case friday
}

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

extension PulseAPI {
    static let apiProtocol = Bundle.main.infoDictionary!["API_PROTOCOL"] as! String
    static let apiVersion = Bundle.main.infoDictionary!["API_VERSION"] as! String
    static let baseURL = Bundle.main.infoDictionary!["API_BASE_URL"] as! String
}

enum PulseAPI {
    
    // Auth
    case login(emailAddress: String, password: String) //
    case signup(emailAddress: String, name: String, position: String) //
    
    // Feed
    case getTasksAssignedToUser(assigneeId: String, offset: Int) //
    case getTasksCreatedByUser(assignerId: String, offset: Int) //
    
    // Create task
    case createTask(title: String, items: [String], assignees: [String], dueDate: Date?, updateDay: WeekDay) //
    case editTask(params: [String: AnyObject]) //
    
    // Task Updates
    case getTask(taskId: String) //
    case requestTaskUpdate(taskId: String) //
    case sendTaskUpdate(taskId: String, completionPercentage: Float) //
    case finishTask(taskId: String) //
    
    case getUpdateRequests(offset: Int)
    case getUpdates(updateRequestId: String, offset: Int)
    
    // Task Items
    case finishTaskItem(taskId: String, itemId: String) //
    
    // Team members
    case getTeamMembers(teamId: String, offset: Int)
    
    // Experimental
    case getMyTasks
    case getTasksCreated
    case getUpdatesFeed
}

extension PulseAPI {
    var method: HTTPMethod {
        switch self {
            case .getTasksCreatedByUser,
                 .getTasksAssignedToUser,
                 .getTask,
                 .getTeamMembers,
                 .getUpdateRequests,
                 .getUpdates,
                 .getMyTasks,
                 .getTasksCreated,
                 .getUpdatesFeed:
            return .get
            
        case .editTask:
            return .put
        
        case .login,
             .signup,
             .createTask,
             .requestTaskUpdate,
             .sendTaskUpdate,
             .finishTask,
             .finishTaskItem:
            return .post
            
        default: return .get
        }
    }
}

extension PulseAPI {
    var path: String {
        switch self {
        case .login:
            return "/api/\(PulseAPI.apiVersion)/auth/signin"
        case .signup:
            return "/api/\(PulseAPI.apiVersion)/users"
        case .createTask:
            return "/api/\(PulseAPI.apiVersion)/tasks"
        case let .getTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case .getTasksAssignedToUser:
            return "/api/\(PulseAPI.apiVersion)/tasks"
        case .getTasksCreatedByUser:
            return "/api/\(PulseAPI.apiVersion)/tasks"
        case let .editTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .finishTask(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .requestTaskUpdate(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .sendTaskUpdate(taskId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)"
        case let .finishTaskItem(taskId, itemId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/items/\(itemId)"
        case let .getTeamMembers(teamId, _):
            return "/api/\(PulseAPI.apiVersion)/teams/\(teamId)/members/"
        case .getUpdateRequests:
            return "/api/\(PulseAPI.apiVersion)/update_requests"
        case let .getUpdates(updateRequestId, _):
            return "/api/\(PulseAPI.apiVersion)/update_requests/\(updateRequestId)/updates"
        case .getMyTasks:
            return "/api/\(PulseAPI.apiVersion)/feeds/my_tasks"
        case .getTasksCreated:
            return "/api/\(PulseAPI.apiVersion)/feeds/tasks_created"
        case .getUpdatesFeed:
            return "/api/\(PulseAPI.apiVersion)/feeds/updates"
        }
    }
}

extension PulseAPI {
    var url: URL? {
        return URL(string: PulseAPI.apiProtocol + PulseAPI.baseURL + self.path)
    }
}

extension PulseAPI {
    var requiresAuthToken: Bool {
        switch self {
        case .login,
             .signup:
            return false
        default:
            return true
        }
    }
}

extension PulseAPI {
    var parameters: [String: AnyObject]? {
        switch self {
        case let .getTasksCreatedByUser(assignerId, offset):
            return [
                "assigner": assignerId as AnyObject,
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
        case let .getTasksAssignedToUser(assigneeId, offset):
            return [
                "assignee": assigneeId as AnyObject,
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
        case let .createTask(title, items, assignees, dueDate, updateDay):
            var params = [
                "title": title as AnyObject,
                "items": items as AnyObject,
                "assignees": assignees as AnyObject,
                "update_day": updateDay.rawValue as AnyObject
            ] as [String : AnyObject]
            if let dueDate = dueDate {
                params["due_date"] = dueDate.timeIntervalSince1970 as AnyObject
            }
            return params as [String : AnyObject]
            
        case let .getTeamMembers(_, offset):
            return [
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
            
        case let .getUpdateRequests(offset):
            return [
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
        case let .getUpdates(_, offset):
            return [
                "offset": offset as AnyObject,
                "limit": 25 as AnyObject
            ]
               default: return nil
        }
    }
}

extension PulseAPI {
    var headers: [String: String] {
        var assigned: [String: String] = ["Accept": "application/json", "Content-Type": "application/json"]
        if requiresAuthToken { assigned["Authorization"] = "586ecdc0213f22d94db5ef7f" } // TODO: Removed hardcoded id
        
        switch self {
        default: return assigned
        }
    }
}



