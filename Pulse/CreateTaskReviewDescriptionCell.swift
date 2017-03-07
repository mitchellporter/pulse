//
//  CreateTaskReviewDescriptionCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskReviewDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.descriptionLabel.textContainer.lineFragmentPadding = 0
    }
    
    func load(text: String?) {
        self.descriptionLabel.text = text
    }
    
}
