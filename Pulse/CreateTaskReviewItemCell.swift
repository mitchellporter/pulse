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
    var delegate: CreateTaskReviewItemCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.itemLabel.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.itemLabel.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func load(_ string: String) {
        self.string = string
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
