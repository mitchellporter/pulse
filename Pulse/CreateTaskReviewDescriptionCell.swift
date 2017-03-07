//
//  CreateTaskReviewDescriptionCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol CreateTaskReviewDescriptionCellDelegate: class, CreateTaskCellDelegate {
    
    func taskDescriptionReview(cell: CreateTaskReviewDescriptionCell, didUpdate text: String)
}

class CreateTaskReviewDescriptionCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UITextView!
    weak var delegate: CreateTaskReviewDescriptionCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.descriptionLabel.textContainer.lineFragmentPadding = 0
    }
    
    func load(text: String?) {
        self.descriptionLabel.text = text
    }
}

extension CreateTaskReviewDescriptionCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.taskDescriptionReview(cell: self, didUpdate: self.descriptionLabel.text)
    }
}
