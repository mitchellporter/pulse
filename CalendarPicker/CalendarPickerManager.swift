//
//  CalendarPickerManager.swift
//  DateWork
//
//  Created by Design First Apps on 12/16/16.
//  Copyright © 2016 Design First Apps. All rights reserved.
//

import UIKit

// TODO: Revisit the previous date selection functionality to possibly present the calendar with the previously selected date already selected rather than reloading the entire collectionView after setting the previous date.

protocol CalendarManagerDelegate {
    func calendarDidPresent(calendar: CalendarPicker)
    func dateSelectionChanged(date: Date?)
    func calendarDidDismiss()
}

class CalendarPickerManager: NSObject {
    
    static let shared = CalendarPickerManager()
    
    private var window: UIWindow?
    private var picker: CalendarPicker?
    private var swipeGesture: UISwipeGestureRecognizer?
    private var pickerPresented = false
    
    var delegate: CalendarManagerDelegate?
    
    var pickerFinalFrame: CGRect {
        if self.pickerPresented == true {
            return self.picker!.frame
        } else {
            return CGRect.zero
        }
    }
    
    var pickerDate: Date? {
        return self.picker?.selectedDate
    }
    
    let pickerAnimationDuration = 0.3
    
    private override init() {}
    
    func presentCalendarPicker(with delegate: CalendarManagerDelegate?) {
        if self.window == nil && self.picker == nil {
            let frame = UIScreen.main.bounds
            self.pickerPresented = true
            self.window = UIWindow(frame: frame)
            self.window?.backgroundColor = UIColor.clear
            let picker = CalendarPicker()
            picker.delegate = self
            picker.frame = CGRect(x: 0, y: frame.height, width: frame.width, height: frame.height*0.6341)
            self.picker = picker
            UIApplication.shared.delegate?.window??.addSubview(picker)
//            window?.addSubview(picker)
//            self.window?.windowLevel = UIWindowLevelNormal
//            self.window?.makeKeyAndVisible()
            self.animatePicker(picker: self.picker, completion: nil)
            
            self.delegate = delegate
            
            // Setup Swipe Gesture
            self.swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissCalendarPicker))
            self.swipeGesture?.direction = UISwipeGestureRecognizerDirection.down
            self.picker?.addGestureRecognizer(self.swipeGesture!)
            
            self.delegate?.calendarDidPresent(calendar: picker)
        }
    }
    
    func dismissCalendarPicker() {
        if self.picker != nil {
            if let gesture = self.picker!.gestureRecognizers?.first {
                self.picker!.removeGestureRecognizer(gesture)
            }
        }
        self.pickerPresented = false
        self.animatePicker(picker: self.picker) { _ in
            self.delegate?.calendarDidDismiss()
            self.delegate = nil
            self.picker?.superview?.removeFromSuperview()
            self.picker?.removeFromSuperview()
            self.picker = nil
            self.swipeGesture = nil
            self.window = nil
        }
    }
    
    private func animatePicker(picker: CalendarPicker?, completion: ((Bool) -> Void)?) {
        guard let picker = picker else { return }
        if self.pickerPresented {
            UIView.animate(withDuration: self.pickerAnimationDuration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                picker.frame.origin.y -= picker.frame.height
            }, completion: nil)
        } else {
            UIView.animate(withDuration: self.pickerAnimationDuration, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: {
                picker.frame.origin.y += picker.frame.height
            }, completion: completion)
        }
    }
    
    func setSelectedPickerDate(date: Date) {
        self.picker?.setSelected(date: date)
    }
}

extension CalendarPickerManager: CalendarDelegate {
    
    func dateSelected(date: Date?) {
        self.delegate?.dateSelectionChanged(date: date)
    }
}
