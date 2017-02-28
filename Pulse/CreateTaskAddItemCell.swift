//
//  CreateTaskAddItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/27/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

let kCreateTaskDescriptionPlaceholder: String = "Give this person a quick high level overview of what you need done."
let kCreateTaskAddItemPlaceHolder: String = "Add Tasks"

protocol CreateTaskAddItemCellDelegate: class {
    func addItemCell(_ cell: CreateTaskAddItemCell, didUpdateDescription text: String)
    func addItemCell(_ cell: CreateTaskAddItemCell, addNew item: String)
}

class CreateTaskAddItemCell: UITableViewCell {
    
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var newItemTextView: UITextView!
    
    weak var delegate: CreateTaskAddItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func addItem() {
        if self.newItemTextView.text != kCreateTaskAddItemPlaceHolder && self.newItemTextView.text != "" {
            self.delegate?.addItemCell(self, addNew: newItemTextView.text)
            newItemTextView.text = kCreateTaskAddItemPlaceHolder
        } else {
            self.newItemTextView.becomeFirstResponder()
        }
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        addItem()
    }
}

extension CreateTaskAddItemCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == kCreateTaskDescriptionPlaceholder || textView.text == kCreateTaskAddItemPlaceHolder {
                textView.selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let zeroRange: NSRange = NSMakeRange(0, 0)
        if textView.text == kCreateTaskDescriptionPlaceholder || textView.text == kCreateTaskAddItemPlaceHolder {
            if (textView.selectedRange.location != zeroRange.location) || (textView.selectedRange.length != zeroRange.length) {
                textView.selectedRange = zeroRange
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView == self.newItemTextView {
                self.addItem()
            }
            textView.resignFirstResponder()
            return false
        }
        
        if textView.text == kCreateTaskDescriptionPlaceholder || textView.text == kCreateTaskAddItemPlaceHolder {
            if text != "" {
                textView.text = ""
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            if textView == self.textView {
                textView.text = kCreateTaskDescriptionPlaceholder
            } else if textView == self.newItemTextView {
                textView.text = kCreateTaskAddItemPlaceHolder
            }
        }
        
        if textView == self.textView {
            self.delegate?.addItemCell(self, didUpdateDescription: self.textView.text)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.newItemTextView && textView.text == "" {
            textView.text = kCreateTaskAddItemPlaceHolder
        }
    }
}
