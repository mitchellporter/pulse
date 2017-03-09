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
    case createTask(title: String, items: [String], assignees: [String], dueDate: Date?, updateDays: [WeekDay]?) //
    case editTask(params: [String: AnyObject]) //
    
    // Task Updates
    case getTask(taskId: String) //
    case requestTaskUpdate(taskId: String) //
    case sendTaskUpdate(taskId: String, completionPercentage: Float) //
    case sendUpdateForUpdateRequest(updateRequestId: String, completionPercentage: Float)
    case finishTask(taskId: String) //
    
    case getUpdateRequests(offset: Int)
    case getUpdates(updateRequestId: String, offset: Int)
    
    // Task Items
    case markTaskItemCompleted(taskId: String, itemId: String) //
    case markTaskItemInProgress(taskId: String, itemId: String)
    
    // Team members
    case getTeamMembers(teamId: String, offset: Int)
    
    // Experimental
    case getMyTasks
    case getTasksCreated
    case getUpdatesFeed
    
    // Task invitations
    case respondToTaskInvitation(taskInvitationId: String, status: TaskInvitationStatus)
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
            
        case .editTask,
             .respondToTaskInvitation,
             .finishTask,
             .markTaskItemInProgress,
             .markTaskItemCompleted:
            return .put
        
        case .login,
             .signup,
             .createTask,
             .requestTaskUpdate,
             .sendTaskUpdate,
             .sendUpdateForUpdateRequest:
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
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/update_requests"
        case let .sendTaskUpdate(taskId, _):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/updates"
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
        case let .respondToTaskInvitation(taskInvitationId, _):
            return "/api/\(PulseAPI.apiVersion)/task_invitations/\(taskInvitationId)"
        case let .sendUpdateForUpdateRequest(updateRequestId, _):
            return "/api/\(PulseAPI.apiVersion)/update_requests/\(updateRequestId)/updates"
        case let .markTaskItemInProgress(taskId, itemId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/items/\(itemId)"
        case let .markTaskItemCompleted(taskId, itemId):
            return "/api/\(PulseAPI.apiVersion)/tasks/\(taskId)/items/\(itemId)"
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
        case let .createTask(title, items, assignees, dueDate, updateDays):
            var params = [
                "title": title as AnyObject,
                "items": items as AnyObject,
                "assignees": assignees as AnyObject
            ] as [String : AnyObject]
            if let dueDate = dueDate {
                params["due_date"] = dueDate.timeIntervalSince1970 as AnyObject
            }
            if let updateDays = updateDays {
                params["update_days"] = updateDays.flatMap { return $0.rawValue } as AnyObject
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
        case let .respondToTaskInvitation(_, status):
            return [
                "status": status.rawValue as AnyObject
            ]
        case .finishTask:
            return [
                "status": "completed" as AnyObject
            ]
        case let .sendTaskUpdate(_, completionPercentage):
            return [
                "completion_percentage": completionPercentage as AnyObject
            ]
        case let .sendUpdateForUpdateRequest(_, completionPercentage):
            return [
                "completion_percentage": completionPercentage as AnyObject
            ]
        case .markTaskItemInProgress:
            return [
                "status": "in_progress" as AnyObject
            ]
        case .markTaskItemCompleted:
            return [
                "status": "completed" as AnyObject
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



