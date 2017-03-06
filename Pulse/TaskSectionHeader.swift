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

    func load(status: TaskStatus, type: TaskCellType) {
        if self.titleLabel == nil || self.markerView == nil {
            self.layout()
        }
        
        switch status {
        case .pending:
            self.title = type == .assigner ? "PENDING TASKS I ASSIGNED" : "MY NEW TASKS"
            self.markerColor = UIColor("FF5E5B")
        case .inProgress:
            self.title = type == .assigner ? "TASKS IN PROGRESS I ASSIGNED" : "MY TASKS IN PROGRESS"
            self.markerColor = UIColor("3EAEFF")
        case .completed:
            self.title = type == .assigner ? "TASKS COMPLETED I ASSIGNED" : "MY COMPLETED TASKS"
            self.markerColor = UIColor.white
        }
    }
    
    private func layout() {
        let view: UIView = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 3, height: self.frame.height)))
        self.markerView = view
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        view.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: 3).isActive = true
        
        let label: UILabel = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = UIColor.white
        self.titleLabel = label
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10).isActive = true
        label.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        
        self.contentView.backgroundColor = UIColor("111A37")
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
