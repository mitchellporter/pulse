//
//  AnimatedTransition.swift
//  Pulse
//
//  Created by Design First Apps on 4/18/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

class AnimatedTransition: NSObject {
    
    init(from fromVC: UIViewController, to toVC: UIViewController) {
        self.originVC = fromVC
        self.destinationVC = toVC
    }
    
    weak private(set) var originVC: UIViewController?
    weak private(set) var destinationVC: UIViewController?
}
