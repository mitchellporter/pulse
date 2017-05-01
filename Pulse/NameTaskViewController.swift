//
//  NameTaskViewController.swift
//  Pulse
//
//  Created by Design First Apps on 5/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

let kNameTaskConstant: String = "Give a brief discription of what you need done…"

class NameTaskViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var charCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addSubtaskButton: UIButton!
    @IBOutlet weak var bottomMenuBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    private func setup() {
        
        self.textView.delegate = self
        self.textView.textColor = UIColor.white.withAlphaComponent(0.56)
        
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        guard let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect) else { return }
        guard let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let resigning: Bool = notification.name == .UIKeyboardWillHide
        let bottomSpace: CGFloat = resigning ? 0.0 : keyboardEndFrame.height
        
        UIView.animate(withDuration: keyboardDuration, delay: 0.0, options: [.curveLinear, .layoutSubviews], animations: {
            self.bottomMenuBottomConstraint.constant = bottomSpace
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func backButtonpressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func addSubTaskButtonPressed(_ sender: UIButton) {
        guard let text: String = textView.text else { return }
        if text.characters.count <= 300 {
            self.performSegue(withIdentifier: "toSubtask", sender: nil)
        }
    }
}

extension NameTaskViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == kNameTaskConstant {
                textView.selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == kNameTaskConstant {
            textView.text = ""
        }
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = kNameTaskConstant
        }
        
        if textView.text == kNameTaskConstant {
            self.textView.textColor = UIColor.white.withAlphaComponent(0.56)
        } else if textView.textColor != UIColor.white {
            textView.textColor = UIColor.white
        }
        
        guard let text: String = textView.text else { return }
        self.charCountLabel.text = textView.text != kNameTaskConstant ? "\(text.characters.count)/300" : "0/300"
        self.charCountLabel.textColor = text.characters.count <= 300 ? UIColor.white : UIColor.red
    }
}
