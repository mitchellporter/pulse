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
    @IBOutlet weak var addButton: Button!
    @IBOutlet weak var minusButton: Button!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 27
    private var circleFrame: CGRect = CGRect(x: 13.5, y: 13.5, width: 285, height: 285)
    private var percentInterval: CGFloat = 0.1
    
    var holdTimer: Timer?
    var updateRequest: UpdateRequest?
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        guard let task: Task = self.task else { return }
//        self.updatePercentFor(task: task)
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
    
    func updatePercentFor(task: Task) {
        let percent: CGFloat = CGFloat(task.completionPercentage)
        self.updateCircleFillbyAdding(percent: percent)
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
        self.circleLayer.frame = self.circleFrame
        self.circleLayer.path = self.getCirclePath().cgPath
        self.circleLayer.fillColor = self.view.backgroundColor?.cgColor
        self.circleLayer.strokeColor = UIColor.white.cgColor
        self.circleLayer.lineWidth = 27
        self.circleView.layer.insertSublayer(self.circleLayer, at: 0)
        
        self.completedCircle.frame = circleLayer.frame
        self.completedCircle.path = circleLayer.path
        self.completedCircle.fillColor = UIColor.clear.cgColor
        self.completedCircle.strokeColor = appGreen.cgColor
        self.completedCircle.lineWidth = 27
        self.completedCircle.strokeStart = 0.0
        self.completedCircle.strokeEnd = 0.0
        self.circleView.layer.insertSublayer(self.completedCircle, above: self.circleLayer)
    }
    
    private func updateCircleFillbyAdding(percent: CGFloat) {
        let strokeEnd: CGFloat = self.completedCircle.strokeEnd + percent < 1 ? self.completedCircle.strokeEnd + percent : 1
        let newStrokeEnd: CGFloat = self.completedCircle.strokeEnd + percent > 0 ? ((strokeEnd * 100).rounded() / 100) : 0.0
        self.percentCompletedLabel.text = String(Int(newStrokeEnd * 100)) + "%"
        let colorHue: CGFloat = self.rangeMap(inputValue: newStrokeEnd, originMin: 0.0, originMax: 1.0, resultMin: 1.0, resultmax: 0.4, percent: false)
        UIView.animate(withDuration: 0.1, animations: {
            self.circleLayer.strokeStart = newStrokeEnd == 0 ? 0.0 : newStrokeEnd
            self.completedCircle.strokeEnd = newStrokeEnd
            self.completedCircle.strokeColor = UIColor(hue: colorHue, saturation: 0.85, brightness: 0.9, alpha: 1.0).cgColor
        })
    }
    
    private func giveFeedback() {
        if #available(iOS 10.0, *) {
            let mediumGenerator = UIImpactFeedbackGenerator(style: .light)
            mediumGenerator.impactOccurred()
            UIDevice.current.playInputClick()
        }
    }
    
    func addPercent() {
        self.giveFeedback()
        self.updateCircleFillbyAdding(percent: self.percentInterval)
    }
    
    func removePercent() {
        self.giveFeedback()
        self.updateCircleFillbyAdding(percent: -self.percentInterval)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        if sender == self.addButton {
            self.addPercent()
        } else {
            self.removePercent()
        }
        let selector = sender == self.addButton ? #selector(TaskUpdateViewController.addPercent) : #selector(TaskUpdateViewController.removePercent)
        self.holdTimer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: selector, userInfo: nil, repeats: true)
    }
    
    @IBAction func addButtonReleased(_ sender: UIButton) {
        self.holdTimer?.invalidate()
        self.holdTimer = nil
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if self.updateRequest != nil {
            UpdateService.sendUpdateForUpdateRequest(updateRequestId: self.updateRequest!.objectId, completionPercentage: Float(self.completedCircle.strokeEnd), success: { (update) in
                // Success, do something
                self.backButtonPressed(self.backButton)
            }, failure: { (error, statusCode) in
                print("Error: \(statusCode) \(error.localizedDescription)")
            })
            
        } else if self.task != nil {
            UpdateService.sendTaskUpdate(taskId: self.task!.objectId, completionPercentage: Float(self.completedCircle.strokeEnd), success: { (update) in
                // Success, do something
                self.backButtonPressed(self.backButton)
            }, failure: { (error, statusCode) in
                print("Error: \(statusCode) \(error.localizedDescription)")
            })
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
