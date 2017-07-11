//
//  Animations.swift
//  Duoo
//
//  Created by Niklas Alvaeus on 22/01/2016.
//  Copyright © 2016 Gravity Not Applicable Limited. All rights reserved.
//

import Foundation
import UIKit


class Animations {
    
    
    static var shakeAnimation: CAKeyframeAnimation = {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.x");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        translation.values = [-5, 5, -5, 5, -3, 3, -2, 2, 0]
        return translation
    }()

    static var slideAnimation: CAKeyframeAnimation = {
        let translation = CAKeyframeAnimation(keyPath: "transform.translation.y");
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        translation.values = [5, 15]
        translation.repeatCount = Float.infinity
        translation.autoreverses = true
        translation.duration = 1
        return translation
    }()
    
}
