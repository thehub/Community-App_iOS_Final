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
    
    var didLayout = false
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if didLayout {
            return
        }
        didLayout = true
        self.layer.cornerRadius = self.frame.height / 2
        
        addShadow()
    }
    
    func addShadow() {
        
        self.layer.shadowColor = UIColor(hexString: "D5D5D5").cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.97
        self.layer.shadowPath = UIBezierPath(rect: self.layer.bounds).cgPath
        self.layer.shadowRadius = 15.0
        
    }
    

    
}
