//
//  TaskCell.swift
//  
//
//  Created by Design First Apps on 2/22/17.
//
//

import UIKit
import Nuke
import UIAdditions

enum TaskCellType {
    case myTask
    case createdTask
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var badge: UIView!
    @IBOutlet weak var assignedLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    // Revisit if this should be one or two labels.
    @IBOutlet weak var duePercentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completedControl: DotControl!
    
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
//        self.avatar.layer.borderColor = UIColor.white.cgColor
//        self.avatar.layer.borderWidth = 2
        
        self.badge.layer.backgroundColor = appRed.cgColor
        self.badge.layer.borderColor = UIColor.white.cgColor
        self.badge.layer.borderWidth = 2
        self.badge.alpha = 0
        self.badge.layer.cornerRadius = 7
        
        let antiAliasingRing: CAShapeLayer = CAShapeLayer()
        antiAliasingRing.fillColor = UIColor.clear.cgColor
        antiAliasingRing.strokeColor = UIColor.white.cgColor
        antiAliasingRing.lineWidth = 1.0
        antiAliasingRing.path = UIBezierPath(roundedRect: self.badge.bounds, cornerRadius: self.badge.layer.cornerRadius).cgPath
        self.badge.layer.addSublayer(antiAliasingRing)
        
        self.containerView.layer.cornerRadius = 8.0
    }
    
    func load(_ object: Any, type: TaskCellType) {
        if let invitation: TaskInvitation = object as? TaskInvitation {
            self.load(invitation, type: type)
            return
        }
        
        if let task: Task = object as? Task {
            self.load(task, type: type)
            return
        }
        
        
        // What happens when this inference fails??.... INFINITE LOOP
//        self.load(object, type: type)
    }
    
    private func load(_ invitation: TaskInvitation, type: TaskCellType) {
        guard let task: Task = invitation.task else { print("There was no task associated with the invitation"); return }
        self.load(task, type: type)
        
        let date: Date? = task.dueDate
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        let dueDate: String = date == nil ? "" : " | " + dateFormatter.string(from: date!)
        self.duePercentLabel.text = type == .createdTask ? "TASK ASSIGNED" + dueDate : "YOUR NEW TASK" + dueDate
        self.duePercentLabel.textColor = appRed
        self.completedControl.alpha = 0.0
    }
    
    private func load(_ task: Task, type: TaskCellType) {
//        self.duePercentLabel.textColor = task.status == TaskStatus.completed.rawValue ? appGreen : UIColor.white
        var duePercentString: String = ""
        if task.status != TaskStatus.completed.rawValue {
            if let dueDate = task.dueDate {
                let diff = dueDate.timeIntervalSince1970 - Date().timeIntervalSince1970
                let daysTillDueDate = Int(round(diff / 86400))
                duePercentString = "Due: \(daysTillDueDate) Days | "
                if dueDate.timeIntervalSince(Date()) <= 86400 {
                    self.duePercentLabel.textColor = appRed
                }
            }
        }
        self.duePercentLabel.text = task.status == TaskStatus.completed.rawValue ? "Completed" : duePercentString + "\(Int(task.completionPercentage))% Done"
        self.descriptionLabel.text = task.title
        
        var user: User?
        switch type {
        case .myTask:
            guard let assigner: User = task.assigner else { print("There was no assigner for the task"); return }
            user = assigner
        case .createdTask:
            guard let assignee: User = task.assignees?.anyObject() as? User else { print("There were no assignees for the task"); return }
            user = assignee
        }

        self.completedControl.percent = CGFloat(0.0)
        self.completedControl.percent = CGFloat(task.completionPercentage / 100)
//        self.completedControl.emptyColor = UIColor("04243B")
//        self.completedControl.completedColor = UIColor("FFFFFF")
        
        guard let name: String = user?.name else { return }
        self.assignedLabel.text = type == .createdTask ? "To: " + name : "From: " + name
        
        guard let avatarURL: String = user?.avatarURL else { print("No avatar url found"); return }
        guard let url: URL = URL(string: avatarURL) else { return }
        Nuke.loadImage(with: url, into: self.avatar)
        
//        self.configureState(for: task)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        self.duePercentLabel.textColor = UIColor.white
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


