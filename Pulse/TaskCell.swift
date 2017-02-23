//
//  TaskCell.swift
//  
//
//  Created by Design First Apps on 2/22/17.
//
//

import UIKit


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
    var stateColor: UIColor {
        switch self.task!.taskStatus {
        case .pending:
            return UIColor("FF5E5B")
        case .needsUpdate:
            return UIColor("F8C01C")
        case .updated:
            return UIColor("1AB17C")
        case .due:
            return UIColor("FFD800")
        case .inProgress:
            return UIColor("FFFFFF")
        case .completed:
            return UIColor("FFFFFF")
        default:
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    func load(task: Task) {
        self.task = task
        
        // Load Name
        // Load Avatar
        // Load Due date
        // Load Progress
        // Load Description
    }
    
    func configureState(for task: Task) {
        self.badge.backgroundColor = self.stateColor
        
        switch task.taskStatus {
        case .pending:
            self.badge.alpha = 1
        case .needsUpdate:
            self.badge.alpha = 1
        case .updated:
            self.badge.alpha = 1
        case .due:
            self.badge.alpha = 1
        case .inProgress:
            self.badge.alpha = 0
        case .completed:
            self.badge.alpha = 0
        default:
            self.badge.alpha = 0
            break
        }
    }
    
}
