//
//  TaskItemEditCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class TaskItemEditCell: UITableViewCell, TaskItemCell {
    
    @IBOutlet weak var button: Button!
    @IBOutlet weak var label: UILabel!
    
    weak var delegate: TaskItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var state: CellState = .unselected {
        didSet {
            self.update(state: self.state)
        }
    }

    func load(item: Item) {
        self.state = item.completed == true ? .selected : .unselected
        self.label.text = item.text
    }
    
    private func update(state: CellState) {
        if state == .selected {
            self.button.isEnabled = false
        }
        self.button.borderColor = state == .selected ? UIColor("2CB585") : UIColor.white
        let image: UIImage? = state == .selected ? #imageLiteral(resourceName: "GreenCheck") : #imageLiteral(resourceName: "Combined Shape")
        self.button.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.1, animations: {
            self.label.alpha = state == .selected ? 0.34 : 1.0
        })
    }
}
