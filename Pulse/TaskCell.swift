//
//  TaskCell.swift
//  
//
//  Created by Design First Apps on 2/22/17.
//
//

import UIKit
import Nuke

enum TaskCellType {
    case assigner
    case assignee
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var badge: UIView!
    @IBOutlet weak var assignedLabel: UILabel!
    
    // Revisit if this should be one or two labels.
    @IBOutlet weak var duePercentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
//    var task: Task? {
//        didSet {
////            self.configureState(for: self.task!)
//        }
//    }
//    
//    var type: TaskCellType!
    
//    var stateColor: UIColor {
//        switch self.task!.taskStatus {
//        case .pending:
//            return UIColor("FF5E5B")
//        case .inProgress:
//            return UIColor("FFFFFF")
//        case .completed:
//            return UIColor("FFFFFF")
//        }
//    }
    
    override func prepareForInterfaceBuilder() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        self.avatar.layer.cornerRadius = 4
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 2
        
        self.badge.layer.borderColor = UIColor.white.cgColor
        self.badge.layer.borderWidth = 2
        self.badge.alpha = 0
    }
    
    func load(invitation: TaskInvitation, type: TaskCellType) {
        guard let task: Task = invitation.task else { print("There was no task associated with the invitation"); return }
        self.load(task: task, type: type)
        
        let date: Date? = task.dueDate
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        let dueDate: String = date == nil ? "" : " | " + dateFormatter.string(from: date!)
        self.duePercentLabel.text = type == .assignee ? "TASK ASSIGNED" + dueDate : "YOUR NEW TASK" + dueDate
        self.duePercentLabel.textColor = appRed
    }
    
    func load(task: Task, type: TaskCellType) {
        self.duePercentLabel.textColor = task.status == TaskStatus.completed.rawValue ? appGreen : UIColor.white
        var duePercentString: String = ""
        if let dueDate = task.dueDate {
            let diff = dueDate.timeIntervalSince1970 - Date().timeIntervalSince1970
            let daysTillDueDate = Int(round(diff / 86400))
            duePercentString = "DUE: \(daysTillDueDate) DAYS | "
        }
        self.duePercentLabel.text = task.status == TaskStatus.completed.rawValue ? "COMPLETED" : duePercentString + "\(Int(task.completionPercentage))% DONE"
        self.descriptionLabel.text = task.title
        
        var user: User?
        switch type {
        case .assignee:
            guard let assigner: User = task.assigner else { print("There was no assigner for the task"); return }
            user = assigner
        case .assigner:
            guard let assignee: User = task.assignees?.anyObject() as? User else { print("There were no assignees for the task"); return }
            user = assignee
        }
//        print(user)
        guard let name: String = user?.name else { return }
        self.assignedLabel.text = type == .assignee ? "ASSIGNED TO: " + name : "ASSIGNED BY: " + name
        
        guard let avatarURL: String = user?.avatarURL else { print("No avatar url found"); return }
        guard let url: URL = URL(string: avatarURL) else { return }
        Nuke.loadImage(with: url, into: self.avatar)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.duePercentLabel.textColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.badge.layer.cornerRadius = self.badge.frame.width / 2
    }
    
    func configureState(for task: Task) {
//        self.badge.backgroundColor = self.stateColor
        
        switch task.taskStatus {
        case .pending:
            self.badge.alpha = 1
        case .inProgress:
            self.badge.alpha = 0
        case .completed:
            self.badge.alpha = 0
        }
    }
}


