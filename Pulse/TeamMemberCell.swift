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
    }
    
    func load(user: User) {
        self.nameLabel.text = user.name
        self.positionLabel.text = user.position
        self.updateLabel.text = "Undefined"
        self.progressControl.percent = 0.5
        
        guard let avatarURL: URL = URL(string: user.avatarURL ?? "") else { return }
        Nuke.loadImage(with: avatarURL, into: self.avatarImageView)
    }
}
