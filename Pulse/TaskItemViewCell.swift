//
//  TaskItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol TaskItemCellDelegate: class {
    func taskUpdated(item: String)
}

protocol TaskItemCell: class {
    weak var delegate: TaskItemCellDelegate? { get set }
    func load(item: Item)
    var state: CellState { get set }
}
enum CellState: Int {
    case selected
    case unselected
}

class TaskItemViewCell: UITableViewCell, TaskItemCell {
    
    weak var delegate: TaskItemCellDelegate?
    
    @IBOutlet weak var button: Button!
    @IBOutlet weak var label: UILabel!

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
        self.button.borderColor = state == .selected ? UIColor("2CB585") : UIColor.white
        let image: UIImage? = state == .selected ? #imageLiteral(resourceName: "GreenCheck") : nil
        self.button.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.1, animations: {
            self.label.alpha = state == .selected ? 0.34 : 1.0
        })
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.state = self.state == .selected ? .unselected : .selected
    }
    
}
