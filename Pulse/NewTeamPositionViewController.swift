//
//  NewTeamPositionViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/15/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NewTeamPositionViewController: Onboarding {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var jobTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var avatarAddButton: UIButton!
    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    
    private var keyboardOrigin: CGFloat = 0.0
    private var backgroundColor: UIColor?
    
    var newUserDictionary: [NewUserKeys : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObserver()
        
        self.nameTextField.becomeFirstResponder()
        self.backgroundColor = self.view.backgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }
    
    private func setupAppearance() {
//        self.view.backgroundColor = appBlue
        self.nextButton.alpha = 0.52
        self.nextButton.isEnabled = false
        let color: UIColor = UIColor.white.withAlphaComponent(0.52)
        let font: UIFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.nameTextField.attributedPlaceholder = NSAttributedString(string: " Full Name", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
        self.jobTextField.attributedPlaceholder = NSAttributedString(string: " Job Title", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
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
        guard let name: String = self.nameTextField.text else { return }
        self.newUserDictionary.updateValue(name, forKey: .name)
        guard let job: String = self.jobTextField.text else { return }
        self.newUserDictionary.updateValue(job, forKey: .position)
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
            guard let toVC: NewTeamPasswordViewController = segue.destination as? NewTeamPasswordViewController else { return }
            toVC.newUserDictionary = self.newUserDictionary
        }
    }
}

extension NewTeamPositionViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        self.nextButtonIs(enabled: !((self.nameTextField.text == nil || self.nameTextField.text == "") && (self.jobTextField.text == nil || self.jobTextField.text == "")))
    }
}
