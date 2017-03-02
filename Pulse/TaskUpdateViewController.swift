//
//  TaskUpdateViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/1/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import QuartzCore
import CoreGraphics

class TaskUpdateViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var percentCompletedLabel: UILabel!
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 27
    private var circleFrame: CGRect = CGRect(x: 13.5, y: 13.5, width: 285, height: 285)
    private var percentInterval: CGFloat = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.updateCircleFillbyAdding(percent: 0.4)
    }

    private func setupAppearance() {
        self.view.backgroundColor = mainBackgroundColor
        
        self.drawCircle()
        
//        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 100, height: 100))
//        
//        let gradient = CAGradientLayer()
//        gradient.frame = path.bounds
//        gradient.colors = [UIColor.magenta.cgColor, UIColor.cyan.cgColor]
//        
//        let shape = CAShapeLayer()
//        shape.path = path.cgPath
//        shape.lineWidth = 2.0
//        shape.strokeColor = UIColor.black.cgColor
//        self.view.layer.addSublayer(shape)
//        
//        let shapeMask = CAShapeLayer()
//        shapeMask.path = path.cgPath
//        gradient.mask = shapeMask
//        
//        self.view.layer.addSublayer(gradient)
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
        circleLayer.lineWidth = 27
        self.circleView.layer.insertSublayer(circleLayer, at: 0)
        
        self.completedCircle.frame = circleLayer.frame
        self.completedCircle.path = circleLayer.path
        self.completedCircle.fillColor = UIColor.clear.cgColor
        self.completedCircle.strokeColor = appGreen.cgColor
        self.completedCircle.lineWidth = 27
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
    
    @IBAction func minusButtonPressed(_ sender: UIButton) {
        self.updateCircleFillbyAdding(percent: -self.percentInterval)
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.updateCircleFillbyAdding(percent: self.percentInterval)
    }
}
