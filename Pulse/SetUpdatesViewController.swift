//
//  SetUpdatesViewController.swift
//  Pulse
//
//  Created by Design First Apps on 5/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class SetUpdatesViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var bottomMenuBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    
    @IBOutlet var dayButtons: [UIButton]!
    
    var set: Set<String> = [] {
        didSet {
            self.enableNextButton(!set.isEmpty)
            print(self.set)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func selectButton(_ button: UIButton, _ selected: Bool) {
        if selected {
            button.backgroundColor = UIColor("1FC176")
            button.setTitleColor(UIColor.white, for: .normal)
            button.layer.borderColor = UIColor.clear.cgColor
            return
        }
        button.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.black, for: .normal)
        button.layer.borderColor = UIColor("959595").cgColor
    }
    
    private func enableNextButton(_ enabled: Bool) {
        if enabled {
            self.skipButton.backgroundColor = UIColor("3EAEFF")
            self.skipButton.setTitle("NEXT", for: .normal)
            self.skipButton.setTitleColor(UIColor.white, for: .normal)
            self.skipButton.layer.borderColor = UIColor.clear.cgColor
            return
        }
        self.skipButton.backgroundColor = UIColor.clear
        self.skipButton.setTitle("SKIP", for: .normal)
        self.skipButton.setTitleColor(UIColor.black, for: .normal)
        self.skipButton.layer.borderColor = UIColor("454545").cgColor
    }
    
    @IBAction func dayButtonPressed(_ sender: UIButton) {
        guard let dayLabel: String = sender.titleLabel?.text else { return }
        
        var day: String = ""
        
        switch (dayLabel) {
        case "MON":
            day = "Monday"
            break
        case "TUE":
            day = "Tuesday"
            break
        case "WED":
            day = "Wednesday"
            break
        case "THUR":
            day = "Thursday"
            break
        case "FRI":
            day = "Friday"
            break
        case "SAT":
            day = "Saturday"
            break
        default:
            return
        }
        
        if self.set.contains(day) {
            self.set.remove(day)
            self.selectButton(sender, false)
            return
        }
        self.set.insert(day)
        self.selectButton(sender, true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toAddFiles", sender: nil)
    }
}
