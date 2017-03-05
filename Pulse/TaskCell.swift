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

// TODO: HANDLE THESE OPTIONALS
class TaskCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var badge: UIView!
    @IBOutlet weak var assignedLabel: UILabel!
    
    // Revisit if this should be one or two labels.
    @IBOutlet weak var duePercentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var task: Task? {
        didSet {
            self.configureState(for: self.task!)
        }
    }
    
    var type: TaskCellType!
    
    var stateColor: UIColor {
        switch self.task!.taskStatus {
        case .pending:
            return UIColor("FF5E5B")
        case .inProgress:
            return UIColor("FFFFFF")
        case .completed:
            return UIColor("FFFFFF")
        }
    }
    
    override func prepareForInterfaceBuilder() {
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupAppearance()
    }
    
    func load(task: Task, type: TaskCellType) {
        self.task = task
        self.type = type
        
        switch self.type! {
        case .assignee:
            self.loadForAssignee()
        case .assigner:
            self.loadForAssigner()
        }
    }
    
    // TODO: Both loads are gross, fix these
    private func loadForAssignee() {
        
        
        Nuke.loadImage(with: URL(string: self.task!.assigner!.avatarURL!)!, into: self.avatar)
        
        // TODO: Shouldn't need bang for data
        if let assigner = self.task!.assigner {
            self.assignedLabel.text = "ASSIGNED BY: \(self.task!.status)"
        } else {
            self.assignedLabel.text = "ASSIGNER WAS NIL AND IT SHOULDN'T HAVE BEEN!"
        }
        
        // Calculate due date label
        let dueDate = self.task!.dueDate!
        let now = Date()
        let diff = dueDate.timeIntervalSince1970 - now.timeIntervalSince1970
        let daysTillDueDate = lround(diff / 86400)
        
        self.duePercentLabel.text = "DUE: \(daysTillDueDate) DAYS | \(Int(self.task!.completionPercentage))% DONE"
        self.descriptionLabel.text = self.task!.title
    }
    
    private func loadForAssigner() {
        
        let assignee = self.task!.assignees?.anyObject() as! User
        self.assignedLabel.text = "ASSIGNED TO: \(assignee.name)"
        
        // Calculate due date label
        let dueDate = self.task!.dueDate!
        let now = Date()
        let diff = dueDate.timeIntervalSince1970 - now.timeIntervalSince1970
        let daysTillDueDate = Int(round(diff / 86400))

        self.duePercentLabel.text = "DUE: \(daysTillDueDate) DAYS | \(Int(self.task!.completionPercentage))% DONE"
        self.descriptionLabel.text = self.task!.title
        
        Nuke.loadImage(with: URL(string: assignee.avatarURL!)!, into: self.avatar)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.textLabel?.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.badge.layer.cornerRadius = self.badge.frame.width / 2
    }
    
    private func setupAppearance() {
        self.avatar.layer.cornerRadius = 4
        self.avatar.layer.borderColor = UIColor.white.cgColor
        self.avatar.layer.borderWidth = 2
        
        self.badge.layer.borderColor = UIColor.white.cgColor
        self.badge.layer.borderWidth = 2
        self.badge.alpha = 0
    }
    
    func configureState(for task: Task) {
        self.badge.backgroundColor = self.stateColor
        
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


