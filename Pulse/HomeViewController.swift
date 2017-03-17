//
//  HomeViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/3/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var createbutton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var userField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "user_id") != nil {
            self.userField.isHidden = true
        }
        
        self.setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.signInButtonPressed(self.signInButton)
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = mainBackgroundColor
        self.createbutton.backgroundColor = appBlue
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    func updateUserDefaults() {
        let defaults = UserDefaults.standard
        let username = self.userField.text ?? "mitchell"
        switch username {
            case "kori":
            defaults.set("585c2130f31b2fbff4efbf68", forKey: "user_id")
            defaults.synchronize()
            case "mitchell":
            defaults.set("586ecdc0213f22d94db5ef7f", forKey: "user_id")
            defaults.synchronize()
            case "arch":
            defaults.set("58c70df6105bd171feeb2cbc", forKey: "user_id")
            defaults.synchronize()
        default: break
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.userField.isHidden == false {
            self.updateUserDefaults()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
