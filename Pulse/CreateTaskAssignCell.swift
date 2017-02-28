//
//  CreateTaskAssignCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskAssignCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var addButton: Button!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.avatarView.layer.cornerRadius = 4
        self.avatarView.layer.borderColor = UIColor.white.cgColor
        self.avatarView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func load() {
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        //
    }
}
