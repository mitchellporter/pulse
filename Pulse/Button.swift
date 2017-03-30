//
//  Button.swift
//  Hummingbird
//
//  Created by Design First Apps on 11/21/16.
//  Copyright © 2016 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import KGHitTestingViews

@IBDesignable
open class Button: KGHitTestingButton {
    
    // ImageView is present unless this is a system button, then it is nil.
    // Temp solution here to remove optional.
//    override var imageView: UIImageView {
//        if self.buttonType == .system {
//            return UIImageView(frame: self.bounds)
//        }
//        return super.imageView!
//    }
    
    override open func prepareForInterfaceBuilder() {
        
        //
        
    }
    
    @IBInspectable var bounces: Bool = true
    
    override open var adjustsImageWhenHighlighted: Bool {
        get {
            if self.bounces {
                return false
            }
            return super.adjustsImageWhenHighlighted
        }
        set {
            super.adjustsImageWhenHighlighted = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.animatePress()
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.animateRelease()
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.animateRelease()
    }
    
    func animatePress() {
        if !self.bounces { return }
        let ninetyPercent = CATransform3DMakeScale(0.9, 0.9, 1)
        UIView.animate(withDuration: 0.2, animations: {
            self.layer.transform = ninetyPercent
        })
    }
    
    func animateRelease() {
        if !self.bounces { return }
        let oneHundredFivePercent = CATransform3DMakeScale(1.05, 1.05, 1)
        let ninetyFivePercent = CATransform3DMakeScale(0.95, 0.95, 1)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
            self.layer.transform = oneHundredFivePercent
        }, completion: {_ in
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
                self.layer.transform = ninetyFivePercent
            }, completion: {_ in
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .allowUserInteraction, animations: {
                    self.layer.transform = CATransform3DIdentity
                }, completion: {_ in
                })
            })
        })
    }
}

extension Button {
    
    @IBInspectable var cornerRadius: CGFloat {
        get{
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get{
            let color: UIColor = self.layer.borderColor != nil ? UIColor(cgColor:self.layer.borderColor!) : UIColor.white
            return  color
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get{
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
}
