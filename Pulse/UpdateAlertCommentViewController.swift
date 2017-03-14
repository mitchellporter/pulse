//
//  UpdateAlertCommentViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/13/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class UpdateAlertCommentViewController: AlertController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewHeader: UIView!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.textView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.textView.resignFirstResponder()
    }

    private func setupAppearance() {
        self.alertView.layer.cornerRadius = 3
        self.alertViewHeader.backgroundColor = createTaskBackgroundColor
        
        self.textView.text = kUpdateCommentPlaceHolder
        self.textView.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 20)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        guard let previousVC: UpdateAlertController = self.presentingViewController as? UpdateAlertController else { return }
        previousVC.comment = self.textView.text == kUpdateCommentPlaceHolder ? "" : self.textView.text
        self.dismiss(animated: true, completion: nil)
    }
}

extension UpdateAlertCommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == kUpdateCommentPlaceHolder {
                textView.selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let zeroRange: NSRange = NSMakeRange(0, 0)
        if textView.text == kUpdateCommentPlaceHolder {
            if (textView.selectedRange.location != zeroRange.location) || (textView.selectedRange.length != zeroRange.length) {
                textView.selectedRange = zeroRange
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == kUpdateCommentPlaceHolder {
            if text != "" {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = kUpdateCommentPlaceHolder
            textView.textColor = UIColor.black.withAlphaComponent(0.24)
        }
        
        if textView.text != kUpdateCommentPlaceHolder {
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = kUpdateCommentPlaceHolder
        }
        
        if textView.text != "" && textView.text != kUpdateCommentPlaceHolder {
//            self.showCommentBadge(true)
        } else {
//            self.showCommentBadge(false)
        }
    }
}
