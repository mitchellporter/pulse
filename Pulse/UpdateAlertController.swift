//
//  UpdateAlertController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import Nuke

class UpdateAlertController: AlertController {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertViewHeader: UIView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assignedToLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var updateTitleLabel: UILabel!
    @IBOutlet weak var completedPercentageLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var commentBubbleButton: UIButton!
    
    private let requestMessage: String = " would like a progress update now :)"
    
    var holdTimer: Timer?
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 15
    private var circleFrame: CGRect = CGRect(x: 7.5, y: 7.5, width: 160, height: 160)
    private var percentInterval: CGFloat = 0.1
    
    var comment: String = "" {
        didSet {
            let visible: Bool = self.comment == "" ? false : true
            self.showCommentBadge(visible)
        }
    }
    var commentBadge: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupAppearance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let update: Update = self.data as? Update else { return }
        guard let task: Task = update.task else { return }
        if let assigner: User = task.assigner {
            self.updateTitleLabel.text = assigner.name + self.requestMessage
            self.assignedToLabel.text = "Assigned by: \(assigner.name)"
        } else {
            self.assignedToLabel.text = "Assigned by:"
        }
        
        if let date: Date = task.dueDate {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            let percentage: Int = task.completionPercentage > 1 ? 1 : Int(task.completionPercentage)
            self.dueDateLabel.text = "Due: " + formatter.string(from: date) + " | \((percentage * 100))% Done"
        } else {
            self.dueDateLabel.text = ""
        }
        
        self.descriptionLabel.text = task.title
        
        guard let avatarURL: String = task.assigner?.avatarURL else { return }
        guard let url: URL = URL(string: avatarURL) else { return }
        Nuke.loadImage(with: url, into: self.avatarImageView)
    }
    
    private func setupAppearance() {
        self.alertView.layer.cornerRadius = 3
        self.alertViewHeader.backgroundColor = appYellow
        self.avatarImageView.layer.cornerRadius = 4
        
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
    }
    
    fileprivate func showCommentBadge(_ visible: Bool) {
        if visible {
            guard let badge: CALayer = self.commentBadge else { return }
            self.commentBubbleButton.layer.addSublayer(badge)
        } else {
            self.commentBadge?.removeFromSuperlayer()
        }
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
        self.circleLayer.strokeColor = UIColor("F0F0F0").cgColor
        self.circleLayer.lineWidth = self.circleLineWidth
        self.circleView.layer.insertSublayer(self.circleLayer, at: 0)
        
        self.completedCircle.frame = circleLayer.frame
        self.completedCircle.path = circleLayer.path
        self.completedCircle.fillColor = UIColor.clear.cgColor
        self.completedCircle.strokeColor = appGreenAlt.cgColor
        self.completedCircle.lineWidth = self.circleLineWidth
        self.completedCircle.strokeStart = 0.0
        self.completedCircle.strokeEnd = 0.0
        self.circleView.layer.insertSublayer(self.completedCircle, above: self.circleLayer)
    }
    
    private func updateCircleFillbyAdding(percent: CGFloat) {
        let strokeEnd: CGFloat = self.completedCircle.strokeEnd + percent < 1 ? self.completedCircle.strokeEnd + percent : 1
        let newStrokeEnd: CGFloat = self.completedCircle.strokeEnd + percent > 0 ? ((strokeEnd * 100).rounded() / 100) : 0.0
        self.completedPercentageLabel.text = String(Int(newStrokeEnd * 100)) + "%"
        let colorSaturation: CGFloat = self.rangeMap(inputValue: newStrokeEnd, originMin: 0.0, originMax: 1.0, resultMin: 0.0, resultmax: 0.82, percent: false)
        UIView.animate(withDuration: 0.1, animations: {
            self.circleLayer.strokeStart = newStrokeEnd == 0 ? 0.0 : newStrokeEnd
            self.completedCircle.strokeEnd = newStrokeEnd
            self.completedCircle.strokeColor = UIColor(hue: 0.4416, saturation: colorSaturation, brightness: 0.81, alpha: 1.0).cgColor
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let toVC: UpdateAlertCommentViewController = segue.destination as? UpdateAlertCommentViewController else { return }
        toVC.transitioningDelegate = self
        
        guard let comment: String = sender as? String else { return }
        toVC.comment = comment
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
    
    @IBAction func commentButtonPressed(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "comment", sender: self.comment)
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        if let updateRequest: Update = self.data as? Update {
            let comment: String? = self.comment == "" ? nil : self.comment
            let percentage = Float(self.completedCircle.strokeEnd * 100)
            UpdateService.respondToUpdateRequest(updateId: updateRequest.objectId, completionPercentage: percentage, message: comment, success: { (update) in
                // Success, do something
                
                CoreDataStack.shared.saveContext()
                
            }, failure: { (error, statusCode) in
                print("Error: \(statusCode) \(error.localizedDescription)")
            })
            AlertManager.dismissAlert()
        }
    }
}

extension UpdateAlertController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented.isKind(of: UpdateAlertCommentViewController.self) {
            let animator = UpdateAlertCommentAnimator()
            return animator
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.isKind(of: UpdateAlertCommentViewController.self) {
            let animator = UpdateAlertCommentAnimator()
            animator.presenting = false
            return animator
        }
        return nil
    }
}
