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

    
}