//
//  UpdateBreakdownTableViewCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import UIAdditions
import Nuke

class UpdateBreakdownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var percentView: UIView!
    @IBOutlet weak var percentControl: DotControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        self.avatarView.layer.cornerRadius = 4.0
        self.percentControl.percent = 0.0
    }

    func load(_ response: Response) {
        
        guard let user: User = response.assignee else { return }
        self.nameLabel.text = user.name
        self.positionLabel.text = user.position
        
        guard let responseStatus: ResponseStatus = ResponseStatus(rawValue: response.status) else { return }
        if responseStatus == .requested {
            self.percentView.alpha = 0.0
            self.resendButton.alpha = 1.0
        } else {
            // This should be a value loaded from the Update Response.
            self.percentControl.percent = CGFloat(response.completionPercentage / 100)
            self.percentageLabel.text = String(response.completionPercentage) + "%"
        }
        
        guard let avatarURLString: String = user.avatarURL else { return }
        guard let url: URL = URL(string: avatarURLString) else { return }
        Nuke.loadImage(with: url, into: self.avatarView)
    }
    
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        // Resend update request
        
        
        // After successful resend set button to sent state
        self.resendButton.backgroundColor = appGreen
        self.resendButton.setTitle("SENT", for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.resendButton.backgroundColor = appBlue
        self.resendButton.setTitle("RESEND", for: .normal)
    }
}
