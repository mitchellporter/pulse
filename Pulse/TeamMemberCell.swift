//
//  TeamMemberCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/29/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import UIAdditions
import Nuke

class TeamMemberCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var progressControl: DotControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 4
        self.avatarImageView.layer.cornerRadius = 7
        
        self.progressControl.emptyColor = UIColor("EBEBEB")
        self.progressControl.completedColor = UIColor("26CE93")
        self.progressControl.percent = 0.7
    }
    
    func load(user: User) {
        self.nameLabel.text = user.name
        self.positionLabel.text = user.position
        
        if let mostRecentUpdateResponse = user.mostRecentUpdateResponse() {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            guard let date: Date = mostRecentUpdateResponse.createdAt else { return }
            let dateString: String = formatter.string(from: date)
            
            self.updateLabel.text = "Last Update: " + dateString + " | " + "\(Int(mostRecentUpdateResponse.completionPercentage))% Done"
            self.progressControl.percent = CGFloat(mostRecentUpdateResponse.completionPercentage) / 100
        } else {
            self.updateLabel.text = ""
        }
        
        guard let avatarURL: URL = URL(string: user.avatarURL ?? "") else { return }
        Nuke.loadImage(with: avatarURL, into: self.avatarImageView)
    }
}
