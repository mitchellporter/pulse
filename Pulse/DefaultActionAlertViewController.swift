//
//  DefaultActionAlertViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/9/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class DefaultActionAlertViewController: AlertController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadAlert()
    }
    
    private func loadAlert() {
        if let title: String = self.titleText {
            self.titleLabel.text = title
        }
        if let message: String = self.message {
            self.messageLabel.text = message
        }
    }
    

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        AlertManager.dismissAlert()
    }
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        guard let completions = self.completions else { return }
        if completions.count > 0 {
            completions[0]()
        }
        AlertManager.dismissAlert()
    }

}
