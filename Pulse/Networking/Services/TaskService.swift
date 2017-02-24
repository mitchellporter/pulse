//
//  TaskService.swift
//  Pulse
//
//  Created by Mitchell Porter on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias TaskServiceSuccess = (_ task: Task) -> ()
typealias TasksServiceSuccess = (_ tasks: [Task]) -> ()

struct TaskService {
    static func createTask(title: String, items: [String], assignees: [String], dueDate: Date?, updateDay: WeekDay, success: @escaping TaskServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .createTask(title: title, items: items, assignees: assignees, dueDate: dueDate, updateDay: updateDay), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let taskJSON = json["task"].dictionaryObject {
                    let task = Task.from(json: taskJSON as [String : AnyObject], context: CoreDataStack.shared.context)
                    success(task)
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
    
    static func getTasksCreatedByUser(assignerId: String, offset: Int, success: @escaping TasksServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTasksCreatedByUser(assignerId: assignerId, offset: offset), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let tasksJSON = json["tasks"].arrayObject {
                    var tasks = [Task]()
                    tasksJSON.forEach({ (taskJSON) in
                        let task = Task.from(json: taskJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        tasks.append(task)
                    })
                    success(tasks)
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
    
    static func getTasksAssignedToUser(assigneeId: String, offset: Int, success: @escaping TasksServiceSuccess, failure: @escaping PulseFailureCompletion) {
        NetworkingClient.sharedClient.request(target: .getTasksAssignedToUser(assigneeId: assigneeId, offset: offset), success: { (data) in
            let json = JSON(data: data)
            if json["success"].boolValue {
                if let tasksJSON = json["tasks"].arrayObject {
                    var tasks = [Task]()
                    tasksJSON.forEach({ (taskJSON) in
                        let task = Task.from(json: taskJSON as! [String : AnyObject], context: CoreDataStack.shared.context)
                        tasks.append(task)
                    })
                    success(tasks)
                }
            }
        }) { (error, statusCode) in
            failure(error, statusCode)
        }
    }
}
