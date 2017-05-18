//
//  TopMenu.swift
//  ImpactHub
//
//  Created by Niklas on 18/05/2017.
//  Copyright © 2017 Lightful Ltd. All rights reserved.
//

import UIKit

class TopMenu: UIView {
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!

    var contentView : UIView?

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    
    var isShow = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupWithItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupWithItems()
    }
    
    func show() {
        isShow = true
        scrollViewTopConstraint.constant = 0

        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.layoutIfNeeded()
        }) { (_) in
            
        }
        
    }
    
    func hide() {
        isShow = false
        scrollViewTopConstraint.constant = -self.frame.height
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 0
            self.layoutIfNeeded()
        }) { (_) in
            
        }
        

    }
    
    func setupWithItems() {
        
        let gap: CGFloat = 40
        
        let button = buttonWithTitle("Feed")
        scrollContentView.addSubview(button)
        button.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: 20).isActive = true
        button.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true

        let button2 = buttonWithTitle("About")
        scrollContentView.addSubview(button2)
        button2.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: gap).isActive = true
        button2.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true

        let button3 = buttonWithTitle("Projects")
        scrollContentView.addSubview(button3)
        button3.leadingAnchor.constraint(equalTo: button2.trailingAnchor, constant: gap).isActive = true
        button3.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true

        let button4 = buttonWithTitle("Groups")
        scrollContentView.addSubview(button4)
        button4.leadingAnchor.constraint(equalTo: button3.trailingAnchor, constant: gap).isActive = true
        button4.centerYAnchor.constraint(equalTo: scrollContentView.centerYAnchor).isActive = true

    }
    
    func buttonWithTitle(_ title: String) -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor.blue, for: .normal)
        button.setTitleColor(UIColor.white, for: .highlighted)
        button.setTitleColor(UIColor.black, for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitle(title, for: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    func xibSetup() {
        contentView = loadViewFromNib()

        contentView?.clipsToBounds = true
        
        // use bounds not frame or it'll be offset
        contentView!.frame = bounds
        
        // Make the view stretch with containing view
        contentView!.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(contentView!)
        scrollViewTopConstraint.constant = -frame.height
        alpha = 0

        
    }
    
    func loadViewFromNib() -> UIView! {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }

}
