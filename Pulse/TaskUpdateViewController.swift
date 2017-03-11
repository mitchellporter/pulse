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
    @IBOutlet weak var commentButton: UIButton!
    
    // Comment View outlets
    @IBOutlet weak var commentCloseButton: UIButton!
    @IBOutlet weak var commentDoneButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTopBar: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewY: NSLayoutConstraint!
    @IBOutlet weak var commentCoverView: UIView!
    
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 27
    private var circleFrame: CGRect = CGRect(x: 13.5, y: 13.5, width: 285, height: 285)
    private var percentInterval: CGFloat = 0.1
    
    var holdTimer: Timer?
    var updateRequest: UpdateRequest?
    var task: Task?
    
    var commentBadge: CALayer?
    
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
        
        // Setup comment badge
        let circle: CALayer = CALayer()
        circle.frame = CGRect(x: 12, y: -2, width: 12, height: 12)
        circle.backgroundColor = appRed.cgColor
        circle.masksToBounds = true
        circle.cornerRadius = circle.frame.width/2
        let border: CAShapeLayer = CAShapeLayer()
        border.path = UIBezierPath(ovalIn: CGRect(x: 1, y: 1, width: 10, height: 10)).cgPath
        border.strokeColor = UIColor.white.cgColor
        border.lineWidth = 2
        border.fillColor = nil
        circle.addSublayer(border)
        
        self.commentBadge = circle
        
        // Setup comment view
        self.commentView.layer.cornerRadius = 3
        self.commentTopBar.backgroundColor = mainBackgroundColor
        
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
    
    private func showCommentBadge(_ visible: Bool) {
        if visible {
            guard let badge: CALayer = self.commentBadge else { return }
            self.commentButton.layer.addSublayer(badge)
        } else {
            self.commentBadge?.removeFromSuperlayer()
        }
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
    
    private func presentCommentView(_ presenting: Bool) {
        if presenting {
            self.commentCoverView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.commentCoverView.frame = self.view.bounds
            self.view.addSubview(self.commentCoverView)
            self.commentViewY.constant = self.view.bounds.height
            self.view.layoutIfNeeded()
            self.commentViewY.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.commentCoverView.backgroundColor = UIColor.black.withAlphaComponent(0.66)
                self.view.layoutIfNeeded()
            })
        } else {
            self.commentViewY.constant = self.view.bounds.height
            UIView.animate(withDuration: 0.2, animations: {
                self.commentCoverView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.commentCoverView.removeFromSuperview()
            })
        }
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
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        self.presentCommentView(true)
    }
    
    @IBAction func commentViewClosed(_ sender: UIButton) {
        self.presentCommentView(false)
    }
    
    @IBAction func commentDoneButtonPressed(_ sender: UIButton) {
        
    }
}
