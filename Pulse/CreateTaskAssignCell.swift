//
//  CreateTaskAssignCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import Nuke

protocol CreateTaskAssignCellDelegate: class {
    func selectedAssignCell(_ cell: CreateTaskAssignCell)
}

class CreateTaskAssignCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var addButton: Button!
    
    weak var delegate: CreateTaskAssignCellDelegate?

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
    
    func load(teamMember: User) {
        self.nameLabel.text = teamMember.name
        self.positionLabel.text = teamMember.position
        
        guard let avatarURL = teamMember.avatarURL else { return }
        guard let url = URL(string: avatarURL) else { return }
        Nuke.loadImage(with: url, into: self.avatarView)
    }
    
    private func selectUser() {
        
        
        self.delegate?.selectedAssignCell(self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        //
    }
}
