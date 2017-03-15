//
//  NewTeamEmailViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/15/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NewTeamEmailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var takenLabel: UILabel!
    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    
    private var keyboardOrigin: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObserver()
        
        self.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = appBlue
        self.takenLabel.alpha = 0.0
        self.nextButton.alpha = 0.52
        self.nextButton.isEnabled = false
        let color: UIColor = UIColor.white.withAlphaComponent(0.52)
        let font: UIFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.textField.attributedPlaceholder = NSAttributedString(string: " Your Email Address", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
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
        
        self.keyboardOrigin = keyboardEndFrame.origin.y
        
        let resigning = notification.name == .UIKeyboardWillHide ? true: false
        let bottomSpace = resigning ? 20 : keyboardEndFrame.height + 20
        
        UIView.animate(withDuration: keyboardDuration, delay: 0.0, options: [.curveLinear, .layoutSubviews], animations: {
            self.messageBottomConstraint.constant = bottomSpace
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func nextButtonIs(enabled: Bool) {
        self.nextButton.alpha = enabled ? 1.0 : 0.52
        self.nextButton.isEnabled = enabled
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "password", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "password" {
            guard let destination: NewTeamEmailViewController = segue.destination as? NewTeamEmailViewController else { return }
            guard let username: String = sender as? String else { return }
            destination.usernameLabel.text = username
        }
    }
}

extension NewTeamEmailViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        self.nextButtonIs(enabled: !(textField.text == nil || textField.text == ""))
    }
}
