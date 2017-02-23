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

    func load(status: TaskStatus) {
        if self.titleLabel == nil || self.markerView == nil {
            self.layout()
        }
        
        switch status {
        case .pending:
            self.title = "NEW"
            self.markerColor = UIColor("FF5E5B")
        case .needsUpdate:
            self.title = "STATUS UPDATE REQUIRED"
            self.markerColor = UIColor("F8C01C")
        case .updated:
            self.title = "UPDATED STATUS"
            self.markerColor = UIColor("1AB17C")
        case .due:
            self.title = "TASKS DUE"
            self.markerColor = UIColor("FFD800")
        case .inProgress:
            self.title = "TASKS IN PROGRESS"
            self.markerColor = UIColor("3EAEFF")
        case .completed:
            self.title = "TASKS COMPLETED"
            self.markerColor = UIColor.white
        default:
            self.title = ""
        }
    }
    
    private func layout() {
        let view: UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 3, height: self.frame.height)))
        self.markerView = view
        self.contentView.addSubview(view)
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        self.titleLabel = label
        self.contentView.addSubview(label)
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
