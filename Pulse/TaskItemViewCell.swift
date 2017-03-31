//
//  TaskItemCell.swift
//  Pulse
//
//  Created by Design First Apps on 2/24/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

protocol TaskItemCellDelegate: class {
    func taskUpdated(item: String)
}

protocol TaskItemCell: class {
    weak var delegate: TaskItemCellDelegate? { get set }
    func load(item: Item)
    var state: CellState { get set }
}
enum CellState: Int {
    case selected
    case unselected
}

class TaskItemViewCell: UITableViewCell, TaskItemCell {
    
    weak var delegate: TaskItemCellDelegate?
    
    @IBOutlet weak var button: Button!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dot: UIImageView!
    
    var item: Item?

    var state: CellState = .unselected {
        didSet {
            self.update(state: self.state)
        }
    }
    
    func load(item: Item) {
        self.item = item
        self.state = item.itemStatus == .completed ? .selected : .unselected
        self.label.text = item.text
    }
    
    private func update(state: CellState) {
        self.button.borderColor = state == .selected ? UIColor("26CE93") : UIColor("BBBBBB")
        let image: UIImage? = state == .selected ? #imageLiteral(resourceName: "GreenCheck") : nil
        self.button.setImage(image, for: .normal)
        UIView.animate(withDuration: 0.1, animations: {
            self.label.alpha = state == .selected ? 0.22 : 1.0
        })
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let state: CellState = self.state
        self.state = self.state == .selected ? .unselected : .selected
        guard let item: Item = self.item else { return }
        guard let task: Task = item.task else { return }
        if state == .unselected {
            TaskService.markTaskItemCompleted(taskId: task.objectId, itemId: item.objectId, success: { (task) in
                self.state = .selected
            }, failure: { (error, statusCode) in
                // Handle error
                print("Item update error: \(statusCode ?? 000) \(error.localizedDescription)")
                self.state = .unselected
            })
        } else if state == .selected {
            TaskService.markTaskItemInProgress(taskId: task.objectId, itemId: item.objectId, success: { (task) in
                self.state = .unselected
            }, failure: { (error, statusCode) in
                // Handle error
                print("Item update error: \(statusCode ?? 000) \(error.localizedDescription)")
                self.state = .selected
            })
        }
    }
}
