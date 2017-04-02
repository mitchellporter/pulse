//
//  SignInViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/31/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    private var signInFadeAlpha: CGFloat = 0.17
    
    fileprivate var teamId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.teamTextField.becomeFirstResponder()
    }

    private func setupAppearance() {
        self.allowSignIn(false)
        self.teamTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let color: UIColor = UIColor.black.withAlphaComponent(0.17)
        let font: UIFont = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightMedium)
        
        
        self.teamTextField.attributedPlaceholder = NSAttributedString(string: " Enter Your Team", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: " Enter Your Email", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
        self.passwordTextField.attributedPlaceholder = NSAttributedString(string: " Enter Your Password", attributes: [NSForegroundColorAttributeName : color, NSFontAttributeName : font])
    }
    
    fileprivate func presentLogin() {
        
        UIView.animate(withDuration: 0.15, animations: {
            self.teamTextField.alpha = 0.0
        }) { _ in
            UIView.animate(withDuration: 0.15, animations: {
                self.emailTextField.alpha = 1.0
                self.passwordTextField.alpha = 1.0
            }) {_ in
                self.emailTextField.becomeFirstResponder()
            }
        }
    }
    
    fileprivate func allowSignIn(_ allow: Bool) {
        UIView.animate(withDuration: 0.1, animations: { 
            self.signInButton.alpha = allow ? 1.0 : self.signInFadeAlpha
        }) { _ in
            self.signInButton.isEnabled = allow ? true : false
        }
    }

    @IBAction func signInButtonPressed(_ sender: UIButton) {
        guard let teamId: String = self.teamId else { return }
        guard let email: String = self.emailTextField.text else { return }
        guard let password: String  = self.passwordTextField.text else { return }
     
        UserService.signin(teamId: teamId, email: email, password: password, success: { (user) in
            
            self.performSegue(withIdentifier: "toMain", sender: nil)
            
        }) { (error, statusCode) in
            print("Error: \(statusCode ?? 000) \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didChangeText(_ textField: UITextField) {
        if let text = self.passwordTextField.text, let emailText = self.emailTextField.text {
            if text.characters.count > 0 && emailText.characters.count > 0 {
                self.allowSignIn(true)
                return
            }
        }
        self.allowSignIn(false)
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            if textField == self.teamTextField {
                guard let teamName: String = textField.text else { return false }
                AvailabilityService.checkTeamAvailability(teamName: teamName, success: { (available, teamName, teamId) in
                    if !available {
                        self.teamId = teamId
                        self.presentLogin()
                    }
                }, failure: { (error, statusCode) in
                    print("Error: \(statusCode ?? 000) \(error.localizedDescription)")
                })
            }
            if textField == self.emailTextField {
                self.passwordTextField.becomeFirstResponder()
            }
            if textField == self.passwordTextField {
                self.signInButtonPressed(self.signInButton)
            }
            return false
        }
        return true
    }
}
