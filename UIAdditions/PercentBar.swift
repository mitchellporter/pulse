//
//  PercentBar.swift
//  Pulse
//
//  Created by Design First Apps on 3/16/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

/* This class has a temporary size constraint to height: 46 width: 10. In the future the size will be dynamic to maintain the correct aspect ratio. */

@IBDesignable
class DotControl: UIView {
    private var frontDots: CALayer = CALayer()
    private var backDots: CALayer = CALayer()
    
    /*This is the color the control will display to represent the uncompleted percentage of the control.*/
    @IBInspectable var emptyColor: UIColor = UIColor.white {
        didSet {
            self.updateColor(self.emptyColor, for: self.backDots)
        }
    }
    
    /*This is the color the control will display to represent the completed percentage of the control.*/
    @IBInspectable var completedColor: UIColor = UIColor.black {
        didSet {
            self.updateColor(self.completedColor, for: self.frontDots)
        }
    }
    
    /*Percentage the control will display using values between 0.0 and 1.0. The closest valid value will be used for any value outside this range.*/
    @IBInspectable var percent: CGFloat = 0.0 {
        didSet {
            if self.percent > 1.0 {
                self.percent = 1.0
            } else if self.percent < 0.0 {
                self.percent = 0.0
            }
            self.updatePercent(self.percent)
        }
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = CGRect(x: newValue.origin.x, y: newValue.origin.y, width: 46, height: 10)
        }
    }
    
    override init(frame: CGRect) {
        let forceFrame: CGRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: 46, height: 10)
        super.init(frame: forceFrame)
        self.load()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.load()
    }
    
    override func prepareForInterfaceBuilder() {
        self.load()
    }
    
    private func load() {
        self.backgroundColor = UIColor.clear
        self.drawDots(for: self.backDots, with: self.emptyColor)
        self.drawDots(for: self.frontDots, with: self.completedColor)
    }
    
    private func drawDots(for dotLayer: CALayer, with color: UIColor) {
        dotLayer.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 46, height: 10))
        dotLayer.backgroundColor = UIColor.clear.cgColor
        dotLayer.masksToBounds = true
        self.layer.addSublayer(dotLayer)
        
        var originX: CGFloat = 0.0
        for i in 0...3 {
            let circleFrame: CGRect = CGRect(x: originX, y: 0, width: 10, height: 10)
            let circlePath: UIBezierPath = UIBezierPath(ovalIn: circleFrame)
            let circle: CAShapeLayer = CAShapeLayer()
            circle.path = circlePath.cgPath
            circle.fillColor = color.cgColor
            dotLayer.addSublayer(circle)
            originX += circleFrame.width + 2
        }
        
        let percentage: CALayer = CALayer()
        percentage.frame = CGRect(x: 0, y: 0, width: 46, height: 10)
        percentage.opacity = 1.0
        percentage.backgroundColor = UIColor.black.cgColor
        dotLayer.mask = percentage
        
        self.updatePercent(self.percent)
    }
    
    private func updatePercent(_ percent: CGFloat) {
        let backPercent: CGRect = CGRect(x: self.frame.width * percent, y: 0, width: self.frame.width * (1.0 - percent), height: 10)
        let frontPercent: CGRect = CGRect(x: 0, y: 0, width: self.frame.width * percent, height: 10)
        self.backDots.mask?.frame = backPercent
        self.frontDots.mask?.frame = frontPercent
    }
    
    private func updateColor(_ color: UIColor, for layer: CALayer) {
        guard let sublayers: [CALayer] = layer.sublayers else { return }
        for (index, layer) in sublayers.enumerated() {
            print(index)
            layer.backgroundColor = color.cgColor
        }
    }
}
