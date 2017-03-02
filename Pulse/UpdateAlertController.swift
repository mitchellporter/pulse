//
//  UpdateAlertController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class UpdateAlertController: AlertController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewHeader: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var completedPercentageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 15
    private var circleFrame: CGRect = CGRect(x: 7.5, y: 7.5, width: 160, height: 160)
    private var percentInterval: CGFloat = 0.1

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }

    private func setupAppearance() {
        self.alertView.layer.cornerRadius = 3
        self.alertViewHeader.backgroundColor = appGreen
        
        
        
        self.drawCircle()
    }
    
    private func getCirclePath() -> UIBezierPath {
        let path: UIBezierPath = UIBezierPath(arcCenter: CGPoint(x: self.circleFrame.width/2, y: self.circleFrame.height/2), radius: self.circleFrame.width/2, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(M_PI*2.5), clockwise: true)
        return path
    }
    
    func rangeMap(inputValue: CGFloat, originMin: CGFloat, originMax: CGFloat, resultMin: CGFloat, resultmax: CGFloat, percent: Bool) -> CGFloat {
        let result = (( (inputValue - originMin) / (originMax - originMin) ) * (resultmax - resultMin) + resultMin)
        if percent == true {
            return result/100
        } else {
            return result
        }
    }
    
    private func drawCircle() {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = self.circleFrame
        circleLayer.path = self.getCirclePath().cgPath
        circleLayer.fillColor = self.view.backgroundColor?.cgColor
        circleLayer.strokeColor = UIColor("F0F0F0").cgColor
        circleLayer.lineWidth = self.circleLineWidth
        self.circleView.layer.insertSublayer(circleLayer, at: 0)
        
        self.completedCircle.frame = circleLayer.frame
        self.completedCircle.path = circleLayer.path
        self.completedCircle.fillColor = UIColor.clear.cgColor
        self.completedCircle.strokeColor = appGreen.cgColor
        self.completedCircle.lineWidth = self.circleLineWidth
        self.completedCircle.strokeStart = 0.0
        self.completedCircle.strokeEnd = 0.0
        self.circleView.layer.insertSublayer(self.completedCircle, above: circleLayer)
    }
    
    private func updateCircleFillbyAdding(percent: CGFloat) {
        let strokeEnd: CGFloat = self.completedCircle.strokeEnd + percent < 1 ? self.completedCircle.strokeEnd + percent : 1
        let newStrokeEnd: CGFloat = self.completedCircle.strokeEnd + percent > 0 ? ((strokeEnd * 100).rounded() / 100) : 0.0
        self.completedPercentageLabel.text = String(Int(newStrokeEnd * 100)) + "%"
        let colorSaturation: CGFloat = self.rangeMap(inputValue: newStrokeEnd, originMin: 0.0, originMax: 1.0, resultMin: 0.0, resultmax: 0.82, percent: false)
        UIView.animate(withDuration: 0.1, animations: {
            self.completedCircle.strokeEnd = newStrokeEnd
            self.completedCircle.strokeColor = UIColor(hue: 0.4416, saturation: colorSaturation, brightness: 0.81, alpha: 1.0).cgColor
        })
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.updateCircleFillbyAdding(percent: self.percentInterval)
    }
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        self.updateCircleFillbyAdding(percent: -self.percentInterval)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
       AlertManager.dismissAlert()
    }
}
