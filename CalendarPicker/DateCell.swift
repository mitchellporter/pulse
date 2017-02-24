//
//  DateCell.swift
//  DateWork
//
//  Created by Design First Apps on 12/13/16.
//  Copyright © 2016 Design First Apps. All rights reserved.
//

import UIKit

class DateCell: UICollectionViewCell, UIInputViewAudioFeedback {

    @IBOutlet weak var dateLabel: UILabel!
    
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    var date: Date?
    let circle = UIImageView(image: UIImage(named: "HighlightOval"))
    var cellIsSelected = false {
        didSet {
            if self.cellIsSelected {
                self.shouldHighlight(toggle: true)
            } else {
                self.shouldHighlight(toggle: false)
            }
        }
    }
    private(set) var cellIsActive = true {
        didSet {
            if self.cellIsActive {
                self.dateLabel.textColor = UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 1)
            } else {
                self.dateLabel.textColor = UIColor(red: 0.302, green: 0.302, blue: 0.302, alpha: 0.15)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.circle.frame = self.bounds
    }
    
    
    func load(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        self.dateLabel.text = formatter.string(from: date)
        self.date = date
        guard let newDate = Calendar.current.date(from: Calendar.current.dateComponents([.day, .year, .month], from: date)) else { return }
        guard let currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.day, .year, .month], from: Date())) else { return }
        if newDate < currentDate {
            self.cellIsActive = false
        }
    }
    
    override func prepareForReuse() {
        self.cellIsActive = true
        self.dateLabel.text = ""
        self.date = nil
    }
    
    func shouldHighlight(toggle: Bool) {
        if toggle {
            self.circle.alpha = 0
            self.addSubview(self.circle)
            UIView.animate(withDuration: 0.15, animations: {
                self.circle.alpha = 1
            })
        } else {
            self.circle.removeFromSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIDevice.current.playInputClick()
    }
}
