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
    
    func load(task: Task, type: TaskCellType) {
        
        var duePercentString: String = ""
        if let dueDate = task.dueDate {
            let diff = dueDate.timeIntervalSince1970 - Date().timeIntervalSince1970
            let daysTillDueDate = Int(round(diff / 86400))
            duePercentString = "DUE: \(daysTillDueDate) DAYS | "
        }
        self.duePercentLabel.text = duePercentString + "\(Int(task.completionPercentage))% DONE"
        self.descriptionLabel.text = task.title
        
        var user: User = User()
        switch type {
        case .assignee:
            guard let assignee: User = task.assignees?.anyObject() as? User else { print("There were no assignees for the task"); return }
            user = assignee
        case .assigner:
            guard let assigner: User = task.assigner else { print("There was no assigner for the task"); return }
            user = assigner
        }
        self.assignedLabel.text = type == .assignee ? "ASSIGNED TO:" + "\(user.name)" : "ASSIGNED BY:" + "\(user.name)"
        
        guard let avatarURL: String = user.avatarURL else { print("No avatar url found"); return }
        guard let url: URL = URL(string: avatarURL) else { return }
        Nuke.loadImage(with: url, into: self.avatar)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
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


