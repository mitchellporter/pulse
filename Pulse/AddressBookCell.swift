//
//  AddressBookCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol AddressBookCellDelegate: class {
    func contactWasSelected(_ cell: AddressBookCell)
}

class AddressBookCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addButton: Button!
    
    weak var delegate: AddressBookCellDelegate?
    var state: CellState = .unselected {
        didSet {
            self.update(state: self.state)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupAppearance()
    }
    
    private func setupAppearance() {
        self.avatarImageView.layer.cornerRadius = 4
    }
    
    private func update(state: CellState) {
        self.addButton.borderColor = state == .selected ? UIColor.clear : UIColor("C0C0C0")
        let image: UIImage? = state == .selected ? #imageLiteral(resourceName: "GreenCheck") : nil
        self.addButton.setImage(image, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.delegate?.contactWasSelected(self)
    }
}
