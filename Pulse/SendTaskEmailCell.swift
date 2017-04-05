//
//  SendTaskEmailCell.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol SendTaskEmailCellDelegate: class {
    func sendTaskEmailCell(_ cell: SendTaskEmailCell, didChangeText text: String?)
}

class SendTaskEmailCell: UITableViewCell {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    weak var delegate: SendTaskEmailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let color: UIColor = UIColor.black
        let font: UIFont = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightMedium)
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Type an email to invite to task", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
        self.emailTextField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.emailTextField.alpha = 1.0
    }
}

extension SendTaskEmailCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        self.delegate?.sendTaskEmailCell(self, didChangeText: textField.text)
    }
}
