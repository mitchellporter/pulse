//
//  UpdateBreakdownTableViewCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class UpdateBreakdownTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var percentView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        self.avatarView.layer.cornerRadius = 4.0
    }

    func load() {
        // This method needs to take an update progress as a parameter.
    }
    
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        // Resend update request
    }
    
}
