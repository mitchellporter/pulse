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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        self.signInButtonPressed(self.signInButton)
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = appBlue
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
    
    @IBAction func joinButtonPressed(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "toLogin", sender: nil)
        _ = NavigationManager.willSearchAndSetNavigationStackFor(viewControllerClass: TaskViewController.self)
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "skipSignin", sender: nil)
//        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    func updateUserDefaults() {
        let defaults = UserDefaults.standard
        let username = self.userField.text ?? "mitchell"
        switch username {
        case "mitchell":
            defaults.set("586ecdc0213f22d94db5ef7f", forKey: "user_id")
            defaults.set("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ODZlY2RjMDIxM2YyMmQ5NGRiNWVmN2YiLCJpYXQiOjE0ODk1Mjg2ODMsImV4cCI6MTQ5ODE2ODY4M30.ozUcV9aEOEq7k8i_0jJ03aKZD_iT4FtV8DHt2cwyJBY", forKey: "bearer_token")
            defaults.synchronize()
            
            case "kori":
            defaults.set("585c2130f31b2fbff4efbf68", forKey: "user_id")
            defaults.set("Bearer nothing", forKey: "bearer_token")
            defaults.synchronize()
            
            case "allen":
            defaults.set("5881130a387e980f48c743f7", forKey: "user_id")
            defaults.set("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1ODgxMTMwYTM4N2U5ODBmNDhjNzQzZjcifQ.PPFE_iGoi_UGKdETnOv6teeOPmJeUsGWK0lK_fwIPSg", forKey: "bearer_token")
            defaults.synchronize()
            
            case "arch":
            defaults.set("58c70df6105bd171feeb2cbc", forKey: "user_id")
            defaults.set("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1OGM3MGRmNjEwNWJkMTcxZmVlYjJjYmMiLCJpYXQiOjE0ODk1MzA2NTUsImV4cCI6MTQ5ODE3MDY1NX0.ct7VhoZKqyMv0KA0ygvPYbZDmO8-OrKMldCrkavqRRA", forKey: "bearer_token")
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
