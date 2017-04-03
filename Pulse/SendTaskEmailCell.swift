//
//  SendTaskEmailCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class SendTaskEmailCell: UITableViewCell {
    
    @IBOutlet weak var emailTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let color: UIColor = UIColor.black
        let font: UIFont = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Type an email to invite to task", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
    }
}
