//
//  WhiteButton.swift
//  LightfulAdmin
//
//  Created by Niklas on 01/03/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class WhiteButton: UIButton {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.frame.height / 2
        self.titleLabel?.font = UIFont(name: "GTWalsheim-Light", size: 18)
//        self.setTitleColor(UIColor.lightfulVividPurple, for: .normal)
//        self.setTitleColor(UIColor.lightfulVividPurple, for: .highlighted)
//        self.setTitleColor(UIColor.lightfulVividPurple, for: .selected)
//        
        if isEnabled {
            backgroundColor = UIColor.white
        }
        else {
            self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
        }
        
    }
    
    override var isEnabled: Bool {
        didSet {
            switch isEnabled {
            case true:
                backgroundColor = UIColor.white
            case false:
                self.backgroundColor = UIColor.init(white: 1.0, alpha: 0.8)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            switch isHighlighted {
            case true:
                backgroundColor = UIColor.white
            case false:
                backgroundColor = UIColor.white
            }
        }
    }
    
    
}
