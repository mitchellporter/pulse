//
//  TaskSectionHeader.swift
//  Pulse
//
//  Created by Design First Apps on 2/23/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class TaskSectionHeader: UITableViewHeaderFooterView {
    
    init() {
        super.init(reuseIdentifier: "")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layout()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.layout()
    }
    
    private(set) var titleLabel: UILabel!
    var title: String = "" {
        didSet {
            self.load(title: self.title)
        }
    }
    
    var markerView: UIView!
    var markerColor: UIColor = UIColor.white {
        didSet {
            self.markerView.backgroundColor = self.markerColor
        }
    }
    var markerWidth: CGFloat = 3.0 {
        didSet {
            for constraint in self.markerView.constraints {
                if constraint.firstAttribute == .width {
                    self.markerView.removeConstraint(constraint)
                    self.markerView.widthAnchor.constraint(equalToConstant: self.markerWidth).isActive = true
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    private var distanceToTop: CGFloat = 15

    enum CellPosition: Int {
        case top
        case normal
    }

    func load(status: TaskStatus, type: CellPosition) {
        self.distanceToTop = type == .top ? 28 : 15
//        if self.titleLabel == nil || self.markerView == nil {
            self.layout()
//        }
        
        self.markerView.alpha = 0.0
        
        switch status {
        case .pending:
            self.title = "PENDING TASKS"
        case .inProgress:
            self.title = "IN PROGRESS"
        case .completed:
            self.title = "COMPLETED"
        }
        
//        switch status {
//        case .pending:
//            self.title = type == .createdTask ? "PENDING TASKS I ASSIGNED" : "MY NEW TASKS"
//            self.markerColor = appRed
//        case .inProgress:
//            self.title = type == .createdTask ? "TASKS IN PROGRESS I ASSIGNED" : "MY TASKS IN PROGRESS"
//            self.markerColor = appBlue
//        case .completed:
//            self.title = type == .createdTask ? "TASKS COMPLETED I ASSIGNED" : "MY COMPLETED TASKS"
//            self.markerColor = appGreen
//        }
    }
    
    private func layout() {
        if self.markerView != nil {
            self.markerView.removeFromSuperview()
        }
        let view: UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 3, height: self.frame.height)))
        self.markerView = view
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: 3).isActive = true
        view.backgroundColor = self.markerColor
        
        if self.titleLabel != nil {
            self.titleLabel.removeFromSuperview()
        }
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor("191919")
        self.titleLabel = label
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20).isActive = true
        label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: distanceToTop).isActive = true
//        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
//        self.contentView.backgroundColor = mainBackgroundColor
    }
    
    private func load(title: String) {
        self.titleLabel.text = self.title
        self.titleLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        self.title = ""
        self.markerColor = UIColor.white
    }
}
