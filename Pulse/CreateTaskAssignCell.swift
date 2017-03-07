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
    var state: CellState = .unselected {
        didSet {
            self.update()
        }
    }
    var user: User?
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
    
    // Same thing, diff method name :)
    func load(_ user: User) {
        self.nameLabel.text = user.name
        self.positionLabel.text = user.position
        
        guard let avatarURL = user.avatarURL else { return }
        guard let url = URL(string: avatarURL) else { return }
        Nuke.loadImage(with: url, into: self.avatarView)

    }
    
    private func update() {
        let image: UIImage? = self.state == .selected ? #imageLiteral(resourceName: "WhiteCheck") : #imageLiteral(resourceName: "AddPlusWhite")
        self.addButton.setImage(image, for: .normal)
    }
    
    private func selectUser() {
        self.state = self.state == .selected ? .unselected : .selected
        
        self.delegate?.selectedAssignCell(self)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.selectUser()
    }
}
