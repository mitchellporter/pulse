//
//  CreateTaskReviewDescriptionCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskReviewDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
    }

    private func setupAppearance() {
        self.avatarImage.layer.cornerRadius = 4
        self.avatarImage.layer.borderWidth = 2
        self.avatarImage.layer.borderColor = UIColor.white.cgColor
    }
    
}
