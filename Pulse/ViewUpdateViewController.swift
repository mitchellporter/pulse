//
//  ViewUpdateViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class ViewUpdateViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var percentCompletedLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 22
    private var circleFrame: CGRect = CGRect(x: 11, y: 11, width: 240, height: 240)
    private var percentInterval: CGFloat = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupAppearance() {
        self.drawCircle()
        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
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
        circleLayer.strokeColor = UIColor.white.cgColor
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
        self.percentCompletedLabel.text = String(Int(newStrokeEnd * 100)) + "%"
        let colorHue: CGFloat = self.rangeMap(inputValue: newStrokeEnd, originMin: 0.0, originMax: 1.0, resultMin: 1.0, resultmax: 0.4, percent: false)
        UIView.animate(withDuration: 0.1, animations: {
            self.completedCircle.strokeEnd = newStrokeEnd
            self.completedCircle.strokeColor = UIColor(hue: colorHue, saturation: 0.85, brightness: 0.9, alpha: 1.0).cgColor
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

}