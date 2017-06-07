//
//  Button.swift
//  WAYW
//
//  Created by Niklas Alvaeus on 06/09/2016.
//  Copyright © 2016 Gravity Not Applicable Limited. All rights reserved.
//

import UIKit

class Button: UIButton {

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.adjustsImageWhenHighlighted = false
        
    }

    override var isEnabled: Bool {
        didSet {
            switch isEnabled {
            case true:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.alpha = 1.0
                }, completion: nil)
            case false:
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.alpha = 0.5
                }, completion: nil)
            }
        }
    }

    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
                    self.alpha = 0.9
                }, completion: nil)
            }
            else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseInOut, animations: {
                    self.transform = CGAffineTransform.identity
                    self.alpha = 1.0
                }, completion: nil)
            }
        }
    }
    
    
//    func addShadow() {
//        self.layer.shadowColor = UIColor.lightfulDarkGreyBlue.cgColor
//        self.layer.shadowOffset = CGSize(width: 3, height: 3)  //Here you control x and y
//        self.layer.shadowOpacity = 0.05
//        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
//        self.layer.shadowRadius = 20.0 //Here your control your blur
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
}
