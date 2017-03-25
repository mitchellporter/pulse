//
//  NewTeamInviteViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/15/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class NewTeamInviteViewController: Onboarding {
    
    @IBOutlet weak var contactsButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var teamNameLabel: UILabel!

    var teamName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }

    private func setupAppearance() {
        self.teamNameLabel.layer.cornerRadius = 5
        
        self.teamNameLabel.text = self.teamName ?? ""
        
    }

    @IBAction func contactsButtonPressed(_ sender: UIButton) {
        //
    }
    
    @IBAction func emailButtonPressed(_ sender: UIButton) {
        //
    }
    
    @IBAction func skipButtonPressed(_ sender: UIButton) {
        NavigationManager.dismissOnboarding()
    }
}
