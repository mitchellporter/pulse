//
//  NewTeamPasswordViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/15/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NewTeamPasswordViewController: Onboarding {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var messageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var strengthLabel: UILabel!
    
    private var keyboardOrigin: CGFloat = 0.0
    private var strengthLine: CAShapeLayer = CAShapeLayer()

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
//        self.view.backgroundColor = UIColor("ECEFF1")
        self.nextButton.alpha = 0.52
        self.nextButton.isEnabled = false
        let color: UIColor = UIColor.black.withAlphaComponent(0.17)
        let font: UIFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        self.textField.attributedPlaceholder = NSAttributedString(string: " Password", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
        self.textField.tintColor = appBlue
        self.strengthLabel.alpha = 0.0
        self.drawStrengthLine()
    }
    
    private func drawStrengthLine() {
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 205, y: 0))
        
        let defaultStrengthLine: CAShapeLayer = CAShapeLayer()
        defaultStrengthLine.lineWidth = 6
        defaultStrengthLine.path = path.cgPath
        defaultStrengthLine.lineDashPattern = [37, 5]
        defaultStrengthLine.strokeColor = UIColor("D8D8D8").cgColor
        defaultStrengthLine.frame.origin = CGPoint(x: 30, y: UIScreen.main.bounds.height * 0.275)
        
        self.strengthLine.lineWidth = 6
        self.strengthLine.path = path.cgPath
        self.strengthLine.lineDashPattern = [37, 5]
        self.strengthLine.strokeColor = UIColor("D8D8D8").cgColor
//        self.strengthLine.frame.origin = CGPoint(x: 30, y: UIScreen.main.bounds.height * 0.275)
        self.strengthLine.strokeEnd = 0.0
        
        self.view.layer.addSublayer(defaultStrengthLine)
        defaultStrengthLine.addSublayer(self.strengthLine)
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
    
    private func nextButtonIs(enabled: Bool) {
        self.nextButton.alpha = enabled ? 1.0 : 0.52
        self.nextButton.isEnabled = enabled
    }
    
    fileprivate func checkText(_ text: String?) {
        self.nextButtonIs(enabled: !(text == nil || text == ""))
        
        var strokeColor: CGColor = UIColor("D8D8D800").cgColor
        var labelText: String = ""
        var lineEnd: CGFloat = 0.0
        if text != nil {
            if text!.characters.count > 8  || text!.contains(".") {
                lineEnd = 0.8
                labelText = "Strong"
                strokeColor = appGreen.cgColor
            } else if text!.characters.count > 6 {
                lineEnd = 0.4
                labelText = "Medium"
                strokeColor = appYellow.cgColor
            } else if text!.characters.count > 0 {
                lineEnd = 0.2
                labelText = "Weak"
                strokeColor = appRed.cgColor
            }
            self.strengthLabel.alpha = text!.characters.count > 0 ? 1.0 : 0.0
            self.strengthLabel.text = labelText
        }
        
        self.strengthLine.strokeEnd = lineEnd
        
        UIView.animate(withDuration: 0.2, animations: {
            self.strengthLine.strokeColor = strokeColor
            self.strengthLabel.textColor = UIColor(cgColor: strokeColor)
        })
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "invite", sender: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

extension NewTeamPasswordViewController: UITextFieldDelegate {
    
    @IBAction func textFieldDidChange(_ textField: UITextField) {
        self.checkText(textField.text)
    }
}
