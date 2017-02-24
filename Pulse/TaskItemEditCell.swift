//
//  TaskItemEditCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class TaskItemEditCell: UITableViewCell, TaskItemCell {
    
    weak var delegate: TaskItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func load(item: Item) {
        
    }
}
