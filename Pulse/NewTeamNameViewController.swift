//
//  NewTeamNameViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/14/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NewTeamNameViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var takenLabel: UILabel!
    
    private var keyboardOrigin: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupObserver()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeObserver()
    }

    private func setupAppearance() {
        self.view.backgroundColor = appBlue
        self.takenLabel.alpha = 0.0
        let color: UIColor = UIColor.white.withAlphaComponent(0.52)
        let font: UIFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.textField.attributedPlaceholder = NSAttributedString(string: "Your Team Name", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.adjustForKeyboard), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func alertBackground(_ shown: Bool) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.backgroundColor = shown ? appPink : appBlue
            self.takenLabel.alpha = shown ? 1.0 : 0.0
            self.messageViewBottomConstraint.constant = shown ? 0.0 : self.view.frame.height - self.keyboardOrigin
            self.view.layoutIfNeeded()
        }) { (finished) in
            //
        }
    }
    
    fileprivate func checkTeamName(_ name: String?) {
        guard let name: String = name else { self.alertBackground(false); return }
        
        // Check if team name is already taken
        let showAlert: Bool = name.lowercased().contains("b")
        self.alertBackground(showAlert)
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        let userInfo = notification.userInfo!
        guard let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect) else { return }
        guard let keyboardDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.keyboardOrigin = keyboardEndFrame.origin.y
        
        let resigning = notification.name == .UIKeyboardWillHide ? true: false
        let bottomSpace = resigning ? 0.0 : keyboardEndFrame.height
        
        UIView.animate(withDuration: keyboardDuration, delay: 0.0, options: [.curveLinear, .layoutSubviews], animations: {
            self.messageViewBottomConstraint.constant = bottomSpace
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension NewTeamNameViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        self.checkTeamName(textField.text)
    }
}
