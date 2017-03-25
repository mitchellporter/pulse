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

let kUpdateCommentPlaceHolder: String = "Add a message here"

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
    var update: Update?
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
        self.view.backgroundColor = UIColor("ECEFF1")
        self.drawCircle()
        
        // Setup comment badge
        let circle: CALayer = CALayer()
        circle.frame = CGRect(x: 11.5, y: -2.5, width: 11, height: 11)
        circle.backgroundColor = UIColor("FF5E5B").cgColor
        circle.masksToBounds = true
        circle.cornerRadius = circle.frame.width/2
        let border: CAShapeLayer = CAShapeLayer()
        border.path = UIBezierPath(ovalIn: CGRect(x: 0.5, y: 0.5, width: 10, height: 10)).cgPath
        border.strokeColor = UIColor.white.cgColor
        border.lineWidth = 1
        border.fillColor = nil
        circle.addSublayer(border)
        
        self.commentBadge = circle
        
        // Setup comment view
        self.commentView.layer.cornerRadius = 3
        self.commentTopBar.backgroundColor = appYellow
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 20)
        self.commentTextView.text = kUpdateCommentPlaceHolder
        
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
    
    fileprivate func showCommentBadge(_ visible: Bool) {
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
        self.completedCircle.strokeColor = appGreenAlt.cgColor
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
            }, completion: {_ in
                self.commentTextView.becomeFirstResponder()
            })
        } else {
            self.commentTextView.resignFirstResponder()
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
        if self.update != nil {
            
            // TODO: Implement
            let percentage = Float(self.completedCircle.strokeEnd * 100)
            UpdateService.respondToUpdateRequest(updateId: self.update!.objectId, completionPercentage: percentage, message: self.commentTextView.text, success: { (update) in
                // Success, do something
                CoreDataStack.shared.saveContext()
                self.backButtonPressed(self.backButton)
            }, failure: { (error, statusCode) in
                // TODO: Handle failure
            })
        } else if self.task != nil {
            let percentage = Float(self.completedCircle.strokeEnd * 100)
            UpdateService.sendTaskUpdate(taskId: self.task!.objectId, completionPercentage: percentage, message: self.commentTextView.text, success: { (update) in
                // Success, do something
                CoreDataStack.shared.saveContext()
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
        self.commentTextView.text = ""
        self.presentCommentView(false)
    }
    
    @IBAction func commentDoneButtonPressed(_ sender: UIButton) {
        // Add comment to task update and dismiss comment view.
        self.presentCommentView(false)
    }
}

extension TaskUpdateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            if textView.text == kUpdateCommentPlaceHolder {
                textView.selectedRange = NSMakeRange(0, 0)
            }
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let zeroRange: NSRange = NSMakeRange(0, 0)
        if textView.text == kUpdateCommentPlaceHolder {
            if (textView.selectedRange.location != zeroRange.location) || (textView.selectedRange.length != zeroRange.length) {
                textView.selectedRange = zeroRange
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if textView.text == kUpdateCommentPlaceHolder {
            if text != "" {
                textView.text = ""
                textView.textColor = UIColor.black
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text == "" {
                textView.text = kUpdateCommentPlaceHolder
                textView.textColor = UIColor.black.withAlphaComponent(0.24)
        }
        
        if textView.text != kUpdateCommentPlaceHolder {
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = kUpdateCommentPlaceHolder
            textView.textColor = UIColor.black.withAlphaComponent(0.24)
        }
        
        if textView.text != "" && textView.text != kUpdateCommentPlaceHolder {
            self.showCommentBadge(true)
        } else {
            self.showCommentBadge(false)
        }
    }
}
