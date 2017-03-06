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
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.signInButtonPressed(self.signInButton)
    }
    
    private func setupAppearance() {
        self.view.backgroundColor = homeScreenBackgroundColor
        self.createbutton.backgroundColor = createTaskBackgroundColor
    }
    
    @IBAction func createButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
}