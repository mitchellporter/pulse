//
//  ViewUpdateViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import Nuke
import UIAdditions

class ViewUpdateViewController: UIViewController {

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var percentCompletedLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var assignedLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var breakdownButton: UIButton!
    @IBOutlet weak var completedControl: DotControl!
    
    // Comment View outlets
    @IBOutlet weak var commentCloseButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTopBar: UIView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentViewY: NSLayoutConstraint!
    @IBOutlet weak var commentCoverView: UIView!
    
    private var completedCircle: CAShapeLayer = CAShapeLayer()
    private var circleLayer: CAShapeLayer = CAShapeLayer()
    
    private var circleLineWidth: CGFloat = 22
    private var circleFrame: CGRect = CGRect(x: 11, y: 11, width: 240, height: 240)
    private var percentInterval: CGFloat = 0.1
    
    var update: Update? {
        didSet {
            self.checkForComment()
        }
    }
    private var commentAvailable: Bool = false {
        didSet {
            self.commentBadge?.opacity = self.commentAvailable == true ? 1.0 : 0.0
        }
    }
    var commentBadge: CALayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let update: Update = self.update else { return }
        guard let task: Task = update.task else { return }
        if let assignee: User = task.assignees?.allObjects.first as? User {
           self.assignedLabel.text = "Assigned to: \(assignee.name)"
            
            guard let url = URL(string: assignee.avatarURL!) else { return }
            Nuke.loadImage(with: url, into: self.avatarImageView)
            
        } else {
            self.assignedLabel.text = "Assigned to:"
        }
        
        self.descriptionLabel.text = task.title
        
        guard let updateResponses: Set<Response> = update.responses else { return }
        let responses: [Response] = Array(updateResponses)
        
        // Set breakdown button visible if there is more than 1 response to the update.
        self.breakdownButton.alpha = responses.count > 1 ? 1.0 : 0.0
        
        var percentage: Float = 0.0
        for response in responses {
            percentage += response.completionPercentage
        }
        percentage = percentage / Float(responses.count)
        
//        guard let response: Response = update.mostRecentResponse else { return }
        
        let circlePercentage = percentage / 100
        self.updateCircleFillbyAdding(percent: CGFloat(circlePercentage))
        if let date: Date = task.dueDate {
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"

            let percentage = Int(percentage)
            self.dueDateLabel.text = "Due: " + formatter.string(from: date) + " | \(percentage)% Done"
        } else {
            self.dueDateLabel.text = ""
        }
    }
    

    private func setupAppearance() {
        self.drawCircle()
//        self.avatarImageView.layer.borderColor = UIColor.white.cgColor
//        self.avatarImageView.layer.borderWidth = 2
        self.avatarImageView.layer.cornerRadius = 4
        
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
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 20)
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
        self.circleLayer.lineWidth = self.circleLineWidth
        self.circleView.layer.insertSublayer(self.circleLayer, at: 0)
        
        self.completedCircle.frame = circleLayer.frame
        self.completedCircle.path = circleLayer.path
        self.completedCircle.fillColor = UIColor.clear.cgColor
        self.completedCircle.strokeColor = appGreen.cgColor
        self.completedCircle.lineWidth = self.circleLineWidth
        self.completedCircle.strokeStart = 0.0
        self.completedCircle.strokeEnd = 0.0
        self.circleView.layer.insertSublayer(self.completedCircle, above: self.circleLayer)
    }
    
    private func checkForComment() {
        guard let responses: Set<Response> = self.update?.responses else { return }
        let responseArray: [Response] = Array(responses)
        for response in responseArray {
            if response.message != nil {
                self.commentAvailable = true
                return
            }
        }
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
            guard let responses: Set<Response> = self.update?.responses else { return }
            let responseArray: [Response] = Array(responses)
            for response in responseArray {
                if response.message != nil {
                    self.commentTextView.text = response.message
                }
            }
            
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
    
    @IBAction func breakdownButtonPressed(_ sender: UIButton) {
        guard let update: Update = self.update else { return }
        self.performSegue(withIdentifier: "breakdown", sender: update)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func commentButtonPressed(_ sender: UIButton) {
        if self.commentAvailable {
            self.presentCommentView(true)
        }
    }
    
    @IBAction func commentViewClosed(_ sender: UIButton) {
        self.presentCommentView(false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "breakdown" {
            guard let update: Update = sender as? Update else { return }
            guard let responses: Set<Response> = update.responses else { return }
            guard let toVC: ViewUpdateBreakdownViewController = segue.destination as? ViewUpdateBreakdownViewController else { return }
//            toVC.datasource = Array(responses)
            toVC.update = update
        }
    }
}
