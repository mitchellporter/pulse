//
//  AddressBookCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class AddressBookCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        self.avatarImageView.layer.cornerRadius = 4
    }
}
