//
//  CreateTaskReviewItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class CreateTaskReviewItemCell: UITableViewCell {
    
    let dot: CAShapeLayer = CAShapeLayer()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupDot()
    }

    private func setupDot() {
        let frame: CGRect = CGRect(x: 22, y: 18, width: 12, height: 12)
        let path: UIBezierPath = UIBezierPath(ovalIn: frame)
        self.dot.path = path.cgPath
        self.dot.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(self.dot)
    }
    
}
