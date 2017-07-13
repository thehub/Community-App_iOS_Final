//
//  RedButton.swift
//  ImpactHub
//
//  Created by Niklas on 15/06/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class RedButton: Button {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.titleLabel?.font = UIFont(name: "GTWalsheim-Light", size: 16)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.setTitleColor(UIColor.white, for: .selected)
        self.setTitleColor(UIColor.imaWarmGrey, for: .disabled)

        if isEnabled {
            backgroundColor = UIColor.imaGrapefruit
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
    

    
}
