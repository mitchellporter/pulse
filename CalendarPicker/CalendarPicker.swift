//
//  CalendarPicker.swift
//  DateWork
//
//  Created by Design First Apps on 12/14/16.
//  Copyright © 2016 Design First Apps. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    func dateSelected(date: Date?)
}

@IBDesignable
class CalendarPicker: UIView, UIInputViewAudioFeedback {
    
    private(set) var view: UIView!
    
    override init(frame: CGRect) {
    
//         1. setup any properties here
        
//         2. call super.init(frame:)
        super.init(frame: frame)
        
//         3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }

    func xibSetup() {
        view = self.loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = self.bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        self.addSubview(view)
        self.viewDidLoad()
    }
    
    private func loadViewFromNib() -> UIView {
        self.backgroundColor = UIColor.clear
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CalendarPicker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    // End Initialization
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       super.touchesBegan(touches, with: event)
        
        UIDevice.current.playInputClick()
    }
    // FADE LEFT ARROW BUTTON TO 0.24 ALPHA and disable when month is current.
    
    @IBOutlet weak var monthLabelButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var backArrowButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewlayout: UICollectionViewFlowLayout!
    @IBOutlet var dayLabels: [UILabel]!
    
    weak var delegate: CalendarDelegate?
    
    fileprivate var currentDate = Date()
    fileprivate(set) var selectedDate: Date? {
        didSet {
            self.delegate?.dateSelected(date: self.selectedDate)
        }
    }
    
    private let circle: UIImageView = UIImageView()
    
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    private func viewDidLoad() {
        self.setupCalendar()
        self.setupAppearance()
        self.setupCollectionView()
    }
    
    private func setupAppearance() {
        let bundle: Bundle = Bundle(for: type(of: self))
        let image = UIImage(named: "HighlightOval", in: bundle, compatibleWith: nil)
        self.circle.image = image
        self.updateMonth(newDate: self.currentDate)
    }
    
    private func setupCollectionView() {
        let bundle: Bundle = Bundle(for: type(of: self))
        let dateCell = UINib(nibName: "DateCell", bundle: bundle)
        self.collectionView.register(dateCell, forCellWithReuseIdentifier: "dateCell")
        self.collectionViewlayout.itemSize = CGSize(width: self.collectionView.bounds.width/7, height: self.collectionView.bounds.height/5)
    }
    
    private func setupCalendar() {
        let today = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        guard let weekdayComponent = calendar.dateComponents([.weekday], from: today).weekday else { return }
        
        for i in 0...6 {
            guard let updatedWeekdayDate = calendar.date(byAdding: .weekday, value: (-weekdayComponent + 1 + i), to: today) else { return }
            let dayString = formatter.string(from: updatedWeekdayDate)
            let upperDayString = dayString.uppercased()
            self.dayLabels[i].text = upperDayString
        }
    }
    
    func getEndFrame() -> CGRect {
        let bounds = UIScreen.main.bounds
        let endFrame = CGRect(x: 0, y: bounds.height - self.frame.height, width: self.frame.width, height: self.frame.height)
        return endFrame
    }
    
    private func advanceMonth(date: Date) -> Date {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: date)
        return nextMonth!
    }
    
    private func regressMonth(date: Date) -> Date {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: date)
        return previousMonth!
    }
    
    private func updateMonth(newDate: Date) {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        guard let correctedDate = calendar.date(byAdding: .day, value: -(calendar.component(.day, from: newDate) - 1), to: newDate) else { self.currentDate = Date(); return }
        self.currentDate = correctedDate
        formatter.dateFormat = "MMMM"
        self.monthLabelButton.setTitle(formatter.string(from: self.currentDate), for: .normal)
        formatter.dateFormat = "YYYY"
//        self.yearLabel.text = formatter.string(from: self.currentDate)
    }
    
    func setSelected(date: Date) {
        self.selectedDate = date
        self.collectionView.reloadData()
    }
    
    @IBAction func arrowButtonPressed(_ sender: UIButton) {
        let newDate = self.advanceMonth(date: self.currentDate)
        self.updateMonth(newDate: newDate)
        self.circle.removeFromSuperview()
        self.collectionView.reloadData()
    }
    
    @IBAction func backArrowPressed(_ sender: UIButton) {
        let newDate = self.regressMonth(date: self.currentDate)
        self.updateMonth(newDate: newDate)
        self.circle.removeFromSuperview()
        self.collectionView.reloadData()
    }
    
    @IBAction func monthTapped() {
        self.circle.removeFromSuperview()
        self.updateMonth(newDate: Date())
        self.collectionView.reloadData()
    }

    fileprivate func setCellSelected(cell: DateCell, date: Date, animation: Bool) {
        if self.circle.superview == cell {
            self.selectedDate = nil
            self.circle.removeFromSuperview()
        } else {
            self.selectedDate = date
            cell.insertSubview(self.circle, belowSubview: cell.dateLabel)
//            cell.addSubview(self.circle)
            self.circle.frame.size = CGSize(width: cell.bounds.width*0.7169, height: cell.bounds.width*0.7169)
            self.circle.center = CGPoint(x: cell.bounds.midX, y: cell.bounds.midY)
            
            if animation {
                self.circle.alpha = 0
                self.circle.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                UIView.animate(withDuration: 0.3, delay: 00, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                    self.circle.transform = CGAffineTransform.identity
                }, completion: nil)
                UIView.animate(withDuration: 0.15, animations: {
                    self.circle.alpha = 1
                })
            }
        }
    }
}

extension CalendarPicker: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dayRange = Calendar.current.range(of: .day, in: .month, for: self.currentDate) else { return 0 }
        let dayCount = dayRange.upperBound - dayRange.lowerBound
        let weekday = Calendar.current.component(.weekday, from: self.currentDate) - 1
        return dayCount + weekday
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
        
        let weekday = Calendar.current.component(.weekday, from: self.currentDate) - 1
        if weekday <= indexPath.item {
            guard let nextDay = Calendar.current.date(byAdding: .day, value: indexPath.item - weekday, to: self.currentDate) else { return cell }
            if let selectedDate = self.selectedDate {
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMMM YYYY"
                if formatter.string(from: nextDay) == formatter.string(from: selectedDate) {
                    self.setCellSelected(cell: cell, date: selectedDate, animation: false)
                }
            }
            cell.load(date: nextDay)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? DateCell else { return }
        _ = Calendar.current.component(.day, from: Date())
        if cell.cellIsActive {
            guard let cellDate = cell.date else { return }
            if #available(iOS 10.0, *) {
                let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
                mediumGenerator.impactOccurred()
                UIDevice.current.playInputClick()
            }
            let cellDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: cellDate)
            guard let sanitizedDate = Calendar.current.date(from: cellDateComponents) else { return }
            guard let currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.day, .year, .month], from: Date())) else { return }
            if sanitizedDate >= currentDate {
                self.setCellSelected(cell: cell, date: sanitizedDate, animation: true)
                UIDevice.current.playInputClick()
            }
        }
    }
}

extension CalendarPicker: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = ""
        return true
    }
}
