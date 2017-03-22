//
//  Utilities.swift
//  Pulse
//
//  Created by Design First Apps on 3/2/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class Delay {
    class func wait(_ delay:Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

func ImageWith(color: UIColor) -> UIImage? {
    let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContext(rect.size)
    guard let context: CGContext = UIGraphicsGetCurrentContext() else { return nil }
    context.setFillColor(color.cgColor)
    context.fill(rect)
    guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
    UIGraphicsEndImageContext()
    
    return image
}
