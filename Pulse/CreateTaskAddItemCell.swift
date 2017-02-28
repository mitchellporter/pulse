//
//  CreateTaskAddItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/27/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol CreateTaskAddItemCellDelegate: class {
    func addItemCell(_ cell: CreateTaskAddItemCell, didUpdateDescription text: String)
    func addItemCell(_ cell: CreateTaskAddItemCell, addNew item: String)
}

class CreateTaskAddItemCell: UITableViewCell {
    
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var newItemTextView: UITextView!
    let kdescriptionPlaceholder: String = "Give this person a quick high level overview of what you need done."
    let kAddItemPlaceHolder: String = "Add Tasks"
    weak var delegate: CreateTaskAddItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func addItem() {
        if self.newItemTextView.text != kAddItemPlaceHolder && self.newItemTextView.text != "" {
            self.delegate?.addItemCell(self, addNew: newItemTextView.text)
            newItemTextView.text = self.kAddItemPlaceHolder
        } else {
            self.newItemTextView.becomeFirstResponder()
        }
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        addItem()
    }
}

extension CreateTaskAddItemCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            if textView == self.newItemTextView {
                self.addItem()
            }
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            self.delegate?.addItemCell(self, didUpdateDescription: self.textView.text)
        }
    }
}
