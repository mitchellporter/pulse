//
//  CreateTaskAddItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/27/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol CreateTaskAddItemCellDelegate: class {
    func addItemCell(_ cell: CreateTaskAddItemCell, didUpdate text: String)
    func addItemCellPressed()
}

class CreateTaskAddItemCell: UITableViewCell {
    
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var textView: UITextView!
    
    weak var delegate: CreateTaskAddItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.delegate?.addItemCellPressed()
    }
}

extension CreateTaskAddItemCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.addItemCell(self, didUpdate: self.textView.text)
    }
}
