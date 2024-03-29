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
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: TaskItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textView.contentInset = UIEdgeInsets.zero
    }
    
    var state: CellState = .unselected {
        didSet {
            self.update(state: self.state)
        }
    }
    
    override var backgroundColor: UIColor? {
        didSet {
            self.textView.backgroundColor = self.contentView.backgroundColor
        }
    }

    func load(item: Item) {
        self.state = item.status == ItemStatus.completed.rawValue ? .selected : .unselected
        self.textView.text = item.text
        self.label.text = item.text
    }
    
    private func update(state: CellState) {
        if state == .selected {
            self.button.isEnabled = false
        }
        self.button.borderColor = state == .selected ? UIColor("26CE93") : UIColor("BBBBBB")
        let image: UIImage? = state == .selected ? #imageLiteral(resourceName: "GreenCheck") : #imageLiteral(resourceName: "Combined Shape")
        self.button.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.1, animations: {
            self.textView.alpha = state == .selected ? 0.22 : 1.0
        })
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
//        self.textView.becomeFirstResponder()
//        self.delegate?.taskUpdated(item: "")
    }
}
