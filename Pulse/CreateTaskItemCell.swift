//
//  CreateTaskItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/27/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol CreateTaskCellDelegate: class {
    func cellNeedsResize(_ cell: UITableViewCell)
}

protocol CreateTaskItemCellDelegate: class, CreateTaskCellDelegate {
    
    func taskItem(cell: CreateTaskItemCell, didUpdate text: String)
    func taskItem(cell: CreateTaskItemCell, remove item: String)
}

class CreateTaskItemCell: UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var removeButton: Button!
    var indexPath: IndexPath!
    weak var delegate: CreateTaskItemCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textView.delegate = self
    }
    
    func load(text: String?, at indexPath:IndexPath) {
        self.indexPath = indexPath
        guard let text: String = text else { return }
        self.textView.text = text
    }
    
    @IBAction func removeItem(_ sender: UIButton) {
        self.delegate?.taskItem(cell: self, remove: self.textView.text)
    }
    
    override func prepareForReuse() {
        self.indexPath = nil
        self.textView.text = ""
    }
}

extension CreateTaskItemCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.delegate?.taskItem(cell: self, didUpdate: textView.text)
    }
}
