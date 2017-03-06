//
//  AlertController.swift
//  Ginger
//
//  Created by Design First Apps on 1/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class AlertController: UIViewController {
    
    var titleText: String?
    var message: String?
    
    var completions = [AlertCompletion]()
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.clear
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.animateIn()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.animateOut()
    }
    
    private func animateIn() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor(black: 1, alpha: 0.74)
        }, completion: { _ in
            //
        })
    }
    
    private func animateOut() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.backgroundColor = UIColor.clear
        }, completion: { _ in
            //
        })
    }
}
