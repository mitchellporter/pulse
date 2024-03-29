//
//  CreateTaskReviewItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol CreateTaskReviewItemCellDelegate: class, CreateTaskCellDelegate {
    
    func taskItemReview(cell: CreateTaskReviewItemCell, didUpdate text: String)
}

class CreateTaskReviewItemCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UITextView!
    var string: String? {
        didSet {
            self.itemLabel.text = self.string
        }
    }
    weak var delegate: CreateTaskReviewItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.itemLabel.textContainer.lineFragmentPadding = 0
    }
    
    func load(_ string: String) {
        self.string = string
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        if self.itemLabel.isFirstResponder {
            self.itemLabel.resignFirstResponder()
        } else {
            self.itemLabel.becomeFirstResponder()
        }
    }
}

extension CreateTaskReviewItemCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.taskItemReview(cell: self, didUpdate: self.itemLabel.text)
    }
}
